%% XBDP Simple RX
% Description: This script is to be used with the Analog Devices X-Band
% Development Platform to demonstrate MATLAB control of the system.
% It allows the user to configure the Rx aspects of the system and then
% capture receive data for all channels on the system.
% This script requires the use of the Analog Devices, Inc. RF
% Microwave Toolbox.
%
% Author: Sam Ringwood
% Date: 6/2022

% Gain Access to the Analog Devices, Inc. RF Microwave Toolbox at:
% https://github.com/analogdevicesinc/RFMicrowaveToolbox

%% Array Mapping
%check channel element maps correctly to hardware!
subarray = ...
    [[1 9 17 25 3 11 19 27];... %subarray 1
    [2 10 18 26 4 12 20 28];... %subarray 2
    [6 14 22 30 8 16 24 32];... %subarray 3
    [5 13 21 29 7 15 23 31]]';  %subarray 4. linear indexed to sray.ArrayMap
subarray_ref = [1 2 5 6]; %subarray reference channels, linear indexed
adc_map = [4 2 1 3]; %ADC map to subarray
adc_ref = 4; %ADC reference channel

%% Config Dev Platform
uri = 'ip:192.168.1.211';

fs_RxIQ = 250e6; %I/Q Data Rate in MSPS

%Setup AD9081 RX
rx = adi.AD9081.Rx;
rx.uri = uri;
rx.EnabledChannels = [1 2 3 4];
rx.MainNCOFrequencies = ones(1,4)*550e6; %NCO Frequency
rx.SamplesPerFrame = 2^12; %Number Of Samples To Capture: 4096
rx.kernelBuffersCount = 1; %Number Of Buffers To Subsequently Capture
rx.EnablePFIRs = true; %MxFE pFIR Configuration; false: Don't Use pFIRs, true: Use pFIRs
rx.PFIRFilenames = 'disabled.cfg';  %MxFE0 pFIR File
data = rx(); %Initialize The Rx System; Grab The Rx Data Into 'data' Matrix
rx.setRegister(hex2dec('FF'),'19'); %Fine DDC Page
rx.setRegister(hex2dec('61'),'283'); %Fine DDC Control, bypass fine NCO

% Setup ADAR1000EVAL1Z in RX Mode
sray = adi.Stingray;
sray.uri = uri;
sray.Frequency = 10e9;
sray.Mode(:) = {'Rx'}; %set mode, 'Rx', 'Tx, 'Disabled'
sray.RxAttn(:) = 1; %1: Attenuation Off, 0: Attenuation On
sray.SteerRx(0,0); %Broadside
sray.RxGain(:) = 127; %127: Highest Gain, 0: Lowest Gain, Decimal Value
sray.LatchRxSettings; %Latch SPI settings to devices
sray(); %constructor to write properties to hardware

%Setup ADXUD1AEBZ, %Rx High Gain Mode
sray.TXRX0        = 0; %0: RX, 1: TX
sray.TXRX1        = 0;
sray.TXRX2        = 0;
sray.TXRX3        = 0;
sray.RxGainMode   = 1; %0: Low Gain, 1: High Gain - RX Mode only
sray.ADF4371Frequency = 14.5e9; %program if using on-board LO PLL
sray.PllOutputSel = 1; %1: ADF4371 RF1 (8 GHz to 16 GHz), 0: ADF4371 RF2 (16 GHz to 32 GHz)

sray.ArrayMap; %Channel Array Map for ADAR1000EVAL1Z. sray.ArrayMap(1) returns channel 2.

sray.RxPowerDown(:) = true; %True: Enable RX Channels

data = rx(); %capture data from ADCs, 4096x4 matrix

sray.RxPowerDown(:) = false; %Power off all Rx channels

combinedComplexData = sum(data,2); %complex addition for all 4 ADCs

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
