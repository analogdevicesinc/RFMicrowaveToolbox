%% XBDP Simple RX
% Description: This script is to be used with the Analog Devices X-Band
% Development Platform to demonstrate MATLAB control of the system.
% It allows the user to configure the Rx aspects of the system and then
% capture receive data for all channels on the system.
% This script requires the use of the Analog Devices, Inc. RF
% Microwave Toolbox.
%
% Date: October 2024

% Gain Access to the Analog Devices, Inc. RF Microwave Toolbox at:
% https://github.com/analogdevicesinc/RFMicrowaveToolbox

clear all, close all, clc

%% Array Mapping
%verify element maps correctly to hardware!
subarray = ...
    [[1 2 5 6 9 10 13 14];... %subarray 1
    [3 4 7 8 11 12 15 16];... %subarray 2
    [19 20 23 24 27 28 31 32];... %subarray 3
    [17 18 21 22 25 26 29 30]]';  %subarray 4 
subarray_ref = [2 4 18 20]; %subarray reference elements
adc_map = [4 2 1 3]; %ADC map to subarray
adc_ref = 4; %ADC reference channel

%% Config Dev Platform
uri = 'ip:192.168.0.101';

fs_RxIQ = 250e6; %I/Q Data Rate in MSPS

%% Setup TDD Engine

tdd = adi.StingrayTDD;
tdd.uri = uri;
% Startup and connect
tdd.SkipInit = true;
tdd();
tdd.Enable = false;
tdd.StartupDelayMilliseconds = 0;

% Configure top level engine
samplesPerFrame = 2^12;
frameLengthMS = samplesPerFrame/fs_RxIQ*1000;
tdd.FrameLengthMilliseconds = frameLengthMS;

% Configure component channels
onTime = 0; offTime = frameLengthMS - 0.1;

% %TDD Channel 0, TX Offload Sync
tdd.FPGATxOffloadSyncOnStartRaw = 0;
tdd.FPGATxOffloadSyncOffStartRaw= 0;
tdd.FPGATxOffloadSyncOnStartMilliseconds = 0;
tdd.FPGATxOffloadSyncOffStartMilliseconds = 0;
tdd.FPGATxOffloadSyncPolarity = true;
tdd.FPGATxOffloadSyncEnable = true;

% %TDD Channel 1, Rx Offload Sync
tdd.FPGARxOffloadSyncOnStartRaw = 0;
tdd.FPGARxOffloadSyncOffStartRaw= 0;
tdd.FPGARxOffloadSyncOnStartMilliseconds = 0;
tdd.FPGARxOffloadSyncOffStartMilliseconds = 0;
tdd.FPGARxOffloadSyncPolarity = true;
tdd.FPGARxOffloadSyncEnable = true;

% %TDD Channel 2, TDD Enable
tdd.FPGATDDEngineOffStartRaw = 0;
tdd.FPGATDDEngineOnStartRaw = 0;
tdd.FPGATDDEngineOnStartMilliseconds = 0;
tdd.FPGATDDEngineOffStartMilliseconds = 0;
tdd.FPGATDDEnginePolarity = false; 
tdd.FPGATDDEngineEnable = true;

% %TDD Channel 3, 
tdd.RxMxFEOffStartRaw = 10; 
tdd.RxMxFEOnStartRaw = 0;
% tdd.RxMxFEOnStartMilliseconds = 0;
% tdd.RxMxFEOffStartMilliseconds = 0;
tdd.RxMxFEPolarity = true;
% tdd.RxMxFEPolarity = false;
tdd.RxMxFEEnable = true;

% %TDD Channel 4
tdd.TxMxFEOffStartRaw = 0;
tdd.TxMxFEOnStartRaw = 0;
tdd.TxMxFEOnStartMilliseconds = 0;
tdd.TxMxFEOffStartMilliseconds = 0;
tdd.TxMxFEPolarity = true;
tdd.TxMxFEEnable = true;

% TDD Channel 5, RF Control
tdd.TxStingrayOffStartRaw = 0;
tdd.TxStingrayOnStartRaw = 0;
tdd.TxStingrayOnStartMilliseconds = 0;
tdd.TxStingrayOffStartMilliseconds = 0;
tdd.TxStingrayPolarity = false;
tdd.TxStingrayEnable = true;

tdd.Enable = true; % fire up the TDD engine

%% Setup AD9081 RX
rx = adi.AD9081.Rx;
rx.uri = uri;
rx.EnabledChannels = [1 2 3 4];
rx.MainNCOFrequencies = ones(1,4)*430e6; %NCO Frequency
rx.SamplesPerFrame = 2^12; %Number Of Samples To Capture: 4096
rx.kernelBuffersCount = 1; %Number Of Buffers To Subsequently Capture
rx.EnablePFIRs = true; %MxFE pFIR Configuration; false: Don't Use pFIRs, true: Use pFIRs
rx.PFIRFilenames = 'disabled.cfg';  %MxFE0 pFIR File

rx.setRegister(hex2dec('FF'),'19'); %Fine DDC Page
rx.setRegister(hex2dec('61'),'283'); %Fine DDC Control, bypass fine NCO

rx(); %Initialize The Rx System; Grab The Rx Data Into 'data' Matrix
rx.SkipInit = true; % Skip prop retuning

tdd.Enable = true;
tdd.EnableSyncSoft = true;

% Pull filled buffer
data = rx();

%% Setup ADAR1000EVAL1Z in RX Mode
sray = adi.Stingray;
sray.uri = uri;
rxPhaseCalOffsets = zeros(size(sray.RxGain));
sray.Mode(:) = {'Rx'}; %set mode, 'Rx', 'Tx, 'Disabled'
sray.RxAttn(:) = 1; %1: Attenuation Off, 0: Attenuation On
sray.RxGain(:) = 127; %127: Highest Gain, 0: Lowest Gain, Decimal Value
sray(); %constructor to write properties to hardware
sray.SteerRx(0,0,rxPhaseCalOffsets); %Broadside
sray.LatchRxSettings; %Latch SPI settings to devices

%Setup ADXUD1AEBZ, %Rx High Gain Mode
sray.TXRX0        = 0; %0: RX, 1: TX
sray.TXRX1        = 0;
sray.TXRX2        = 0;
sray.TXRX3        = 0;
sray.RxGainMode   = 1; %0: Low Gain, 1: High Gain - RX Mode only
sray.ADF4371Frequency = 14.5e9; %program if using on-board LO PLL
sray.PllOutputSel = 1; %1: ADF4371 RF1 (8 GHz to 16 GHz), 0: ADF4371 RF2 (16 GHz to 32 GHz)

sray.RxPowerDown(:) = false; %Enable RX Channels

for k = 1:2
    %first data buffer clears/discard, second data buffer is used
    data = rx(); %capture data from ADCs, 4096x4 matrix\
end

combinedComplexData = sum(data,2); %complex addition for all 4 ADCs

sray.RxPowerDown(:) = true; %Disable Rx channels

%% Disable TDD
tdd.EnableSyncSoft = false;
tdd.Enable = false;
tdd.FPGATDDEnginePolarity = false;
tdd.Enable = true;
tdd.Enable = false;

%% release
release(rx);
release(sray);
release(tdd);

%% Data Plots

%Sample Domain Plots for Each Subarray
figure 
subplot(2,2,1)
plot(real(data(:,adc_map(1))))
title('Real Value Sample Domain: Subarray 1, ADC3')
xlabel('Sample Number')
ylabel('ADC Code Value')
ylim([-32768 32768]);
yticks(linspace(-2^15, 2^15, 11));
yticklabels({'-32768' '-26214' '-19661' '-13107' '-6554' '0' '6554' '13107' '19661' '26214' '32768'});
xlim([0 2^12]);
grid on;

subplot(2,2,2)
plot(real(data(:,adc_map(2))))
title('Real Value Sample Domain: Subarray 2, ADC1')
xlabel('Sample Number')
ylabel('ADC Code Value')
ylim([-32768 32768]);
yticks(linspace(-2^15, 2^15, 11));
yticklabels({'-32768' '-26214' '-19661' '-13107' '-6554' '0' '6554' '13107' '19661' '26214' '32768'});
xlim([0 2^12]);
grid on;

subplot(2,2,3)
plot(real(data(:,adc_map(3))))
title('Real Value Sample Domain: Subarray 3, ADC0')
xlabel('Sample Number')
ylabel('ADC Code Value')
ylim([-32768 32768]);
yticks(linspace(-2^15, 2^15, 11));
yticklabels({'-32768' '-26214' '-19661' '-13107' '-6554' '0' '6554' '13107' '19661' '26214' '32768'});
xlim([0 2^12]);
grid on;

subplot(2,2,4)
plot(real(data(:,adc_map(4))))
title('Real Value Sample Domain: Subarray 4, ADC2')
xlabel('Sample Number')
ylabel('ADC Code Value')
ylim([-32768 32768]);
yticks(linspace(-2^15, 2^15, 11));
yticklabels({'-32768' '-26214' '-19661' '-13107' '-6554' '0' '6554' '13107' '19661' '26214' '32768'});
xlim([0 2^12]);
grid on;

%plot sample domain of entire array
figure
plot(real(combinedComplexData))
hold on
plot(imag(combinedComplexData))
title('Sample Domain: Entire Array')
xlabel('Sample Number')
ylabel('ADC Code Value')
xlim([0 4095])
ylim([-2^17 2^17])
ylim([-131072 131072]);
yticks(linspace(-2^17, 2^17, 11));
yticklabels({'-131072' '-104858' '-78643' '-52429' '-26215' '0' '26215' '52429' '78643' '104858' '131072'});
xlim([0 2^12]);
grid on;
legend('Real', 'Imag')

%Calculate FFT of sample domain data for frequency response plots
hanningWindow = hanning(rx.SamplesPerFrame);
hanNoiseEqBw = enbw(hanningWindow);
scalingFactor = sqrt(hanNoiseEqBw)*(rx.SamplesPerFrame/2)*2^15;
scalingFactorArray = sqrt(hanNoiseEqBw)*(rx.SamplesPerFrame/2)*2^17; %bit growth due to coherent combining 4 ADCs

%FFT for each subarray
complexData = data./scalingFactor;
windowedData = complexData.*hanningWindow;
fftComplex = fft(windowedData);
fftComplexShifted = fftshift(fftComplex);
fftMags = abs(fftComplexShifted);
fftMagsdB = 20*log10(fftMags);
freqAxis = linspace((-fs_RxIQ/1e6/2), (fs_RxIQ/1e6/2), length(fftMagsdB));

%FFT for entire array
complexDataArray = combinedComplexData./scalingFactorArray;
windowedDataArray = complexDataArray.*hanningWindow;
fftComplexArray = fft(windowedDataArray);
fftComplexShiftedArray = fftshift(fftComplexArray);
fftMagsArray = abs(fftComplexShiftedArray);
fftMagsdBArray = 20*log10(fftMagsArray);

%frequency response plot for each subarray
figure
subplot(2,2,1)
plot(freqAxis, fftMagsdB(:,adc_map(1)))
grid on;
hold on;
title('Frequency Response Of Subarray 1');
xlabel('Frequency (MHz)','FontSize',12);
ylabel('Amplitude (dBFS)','FontSize',12);
axis([-fs_RxIQ/1e6/2, fs_RxIQ/1e6/2, -120, 0]);

subplot(2,2,2)
plot(freqAxis, fftMagsdB(:,adc_map(2)))
grid on;
hold on;
title('Frequency Response Of Subarray 2');
xlabel('Frequency (MHz)','FontSize',12);
ylabel('Amplitude (dBFS)','FontSize',12);
axis([-fs_RxIQ/1e6/2, fs_RxIQ/1e6/2, -120, 0]);

subplot(2,2,3)
plot(freqAxis, fftMagsdB(:,adc_map(3)))
grid on;
hold on;
title('Frequency Response Of Subarray 3');
xlabel('Frequency (MHz)','FontSize',12);
ylabel('Amplitude (dBFS)','FontSize',12);
axis([-fs_RxIQ/1e6/2, fs_RxIQ/1e6/2, -120, 0]);

subplot(2,2,4)
plot(freqAxis, fftMagsdB(:,adc_map(4)))
grid on;
hold on;
title('Frequency Response Of Subarray 4');
xlabel('Frequency (MHz)','FontSize',12);
ylabel('Amplitude (dBFS)','FontSize',12);
axis([-fs_RxIQ/1e6/2, fs_RxIQ/1e6/2, -120, 0]);

%frequency response plot for entire array
figure
plot(freqAxis, fftMagsdBArray)
grid on;
hold on;
title('Frequency Response Of Entire Array');
xlabel('Frequency (MHz)','FontSize',12);
ylabel('Amplitude (dBFS)','FontSize',12);
axis([-fs_RxIQ/1e6/2, fs_RxIQ/1e6/2, -120, 0]);