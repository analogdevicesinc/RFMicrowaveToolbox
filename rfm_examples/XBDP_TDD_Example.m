%% XBDP_TDD_Example.m 
% Description: This script is to be used with the Analog Devices X-Band 
% Development Platform to demonstrate MATLAB control of the system. 
% It allows the user to configure the Rx/Tx aspects of the system, then 
% excercise the TDD core for pulsed radar evaluations. 
% 
% This script configures a Tx duty cycle for the Tx/Rx RF front end and DAC. 
% The ADC continously captures data and fills the buffer for a desired
% duration up to 500 ms due to the FPGA carrier memory limit. 

% This script requires the use of the Analog Devices, Inc. High
% Speed Converter Toolbox and RF & Microwave Toolbox

% Date: October 2024

% Gain Access to the Analog Devices, Inc. High Speed Converter Toolbox at:
% https://github.com/analogdevicesinc/HighSpeedConverterToolbox

% Gain Access to the Analog Devices, Inc. RF & Microwave Toolbox at:
% https://github.com/analogdevicesinc/RFMicrowaveToolbox

clear all, close all, clc

%% Array Mapping
% recommend users verify element maps correctly to hardware
subarray = ...
    [[1 2 5 6 9 10 13 14];... %subarray 1
    [3 4 7 8 11 12 15 16];... %subarray 2
    [19 20 23 24 27 28 31 32];... %subarray 3
    [17 18 21 22 25 26 29 30]]';  %subarray 4 
subarray_ref = [2 4 18 20]; %subarray reference elements
dac_map = [4 3 2 1]; %DAC map to subarray
dac_ref = 4; %DAC reference channel
adc_map = [4 2 1 3]; %ADC map to subarray
adc_ref = 4; %ADC reference channel

%% Config Dev Platform
uri = 'ip:192.168.0.101';

interFreqTx = 4.5e9; %Tx NCO Frequency & Unfolded Rx NCO Frequency [Hz]
interFreqRx = 434e6; % Folder Rx NCO Frequency [Hz]
samplingRate = 250e6;

%% Setup AD9081 Tx & Rx
tx = adi.AD9081.Tx;
tx.uri = uri;
tx.EnabledChannels = [1 2 3 4];%Enabled Tx Channels, Only Needed for DMA
tx.NCOEnables = ones(1,4);
tx.MainNCOFrequencies = ones(1,4)*interFreqTx; %NCO Frequency
tx.MainNCOPhases = zeros(1,4); %NCO Phase
tx.DataSource = 'DMA'; %'DMA' or 'DDS'
tx.EnableCyclicBuffers = 1; %0: Don't Cycle Tx Waveform, 1: Cycle Tx Waveform
tx.DDROffloadEnable = false;

rx = adi.AD9081.Rx;
rx.uri = uri;
rx.EnabledChannels = [1 2 3 4];
rx.MainNCOFrequencies = ones(1,4)*interFreqRx;
rx.ChannelNCOFrequencies = zeros(1,4);
rx.MainNCOPhases = zeros(1,4);
rx.ChannelNCOPhases = zeros(1,4);


%% Setup ADAR1000EVAL1Z in Tx Mode
sray = adi.Stingray;
sray.uri = uri;
sray.Mode(:) = {'Tx'}; %set mode, 'Rx', 'Tx, 'Disabled'
sray.TxAttn(:) = true; %1: Attenuation Off, 0: Attenuation On
sray.TxGain(:) = 127; %127: Highest Gain, 0: Lowest Gain
sray.RxAttn(:) = true;
sray.RxGain(:) = 127;
sray(); %Stingray Constructor
sray.LatchTxSettings; %Latch settings to devices
sray.RxGainMode = 0; %0: Low Gain, 1: High Gain, RX Mode only
sray.PABiasOn(:) = -1.06;
sray.TxRxSwitchControl(:) = {'external'}; %spi: SPI TR Control, external: GPIO TR Control

%% Configure TDD Parameters
frameLengthMS = 1; % duration of one frame units of ms
adcCaptureTimeMS = 4; % duration of rx adc capture in units of ms. 
% If a longer duration is wanted, then the DMA block size needs updated. 
% See IIO buffer DMA max block size on wiki.analog.com
txDutyCycle = 0.1;
txTimeMS = txDutyCycle*frameLengthMS; % duration of txDAC waveform
rxDutyCycle = 1-txDutyCycle;
captureRange = 5; %

txSamplesPerFrame = ((txTimeMS*samplingRate)/1000); % number of samples per frame for DAC, integer value
rxSamplesPerFrame = ((adcCaptureTimeMS*samplingRate)/1000); % number of samples per frame for ADC, integer, value

timeRxSamples = 1/samplingRate:1/samplingRate:rxSamplesPerFrame/samplingRate; % time vector for rx plot

rx.SamplesPerFrame = rxSamplesPerFrame; % max number of samples for all ADCs = 2^24+1 = 16777217
tx.SamplesPerFrame = txSamplesPerFrame;

%% create Waveform

% waveform for one baseband period in buffer size
txSampleRate = samplingRate;
A = 2^15*db2mag(-6); %Tx Baseband Amplitude [dBFS]
B = 1e4; % baseband frequency
T = 1*(txSamplesPerFrame/txSampleRate);
t = linspace(0,T,txSamplesPerFrame);
txSig = A*sin(2*pi*B*t);
waveform = ones(tx.SamplesPerFrame,numel(tx.EnabledChannels)).*txSig';

release(tx)
tx(waveform); %send Tx data

%% Setup TDD
tdd = adi.StingrayTDD;
tdd.uri = uri;
% Startup and connect
tdd.SkipInit = true;
tdd();
tdd.Enable = false;

% Configure top level engine
tdd.StartupDelayMilliseconds = 0;
tdd.FrameLengthMilliseconds = frameLengthMS;

% Configure component channels

%TDD Channel 0, TX Offload Sync
nTx=0; % how many samples to ignore/wait
tdd.FPGATxOffloadSyncOnStartRaw = 0+nTx;
tdd.FPGATxOffloadSyncOffStartRaw = 1;
tdd.FPGATxOffloadSyncPolarity = false;
tdd.FPGATxOffloadSyncEnable = true;

%TDD Channel 1, Rx Offload Sync
nRx=0; % how many samples to ignore/wait
tdd.FPGARxOffloadSyncOnStartRaw = 0+nRx;
tdd.FPGARxOffloadSyncOffStartRaw = nRx+1;
tdd.FPGARxOffloadSyncPolarity = false;
tdd.FPGARxOffloadSyncEnable = true;

%TDD Channel 2, TDD Enable
tdd.FPGATDDEngineOnStartMilliseconds = 0;
tdd.FPGATDDEngineOffStartMilliseconds = 0;
tdd.FPGATDDEnginePolarity = true; % Invert TDD control to allow pure software control
tdd.FPGATDDEngineEnable = true;

%TDD Channel 3, Rx MxFE EN
tdd.RxMxFEOnStartMilliseconds = 0;
tdd.RxMxFEOffStartMilliseconds = 0;
tdd.RxMxFEPolarity = true;
tdd.RxMxFEEnable = true;

%TDD Channel 4, Tx MxFE EN
tdd.TxMxFEOnStartMilliseconds = 0;
tdd.TxMxFEOffStartMilliseconds = txTimeMS;
tdd.TxMxFEPolarity = false;
tdd.TxMxFEEnable = true;

%TDD Channel 5, RF Control
tdd.TxStingrayOnStartMilliseconds = 0;
tdd.TxStingrayOffStartMilliseconds = txTimeMS;
tdd.TxStingrayPolarity = false;
tdd.TxStingrayEnable = true;

tdd.Enable = true; % fire up the TDD engine

%% Soft Start TDD
tdd.EnableSyncSoft = 0;
tdd.EnableSyncSoft = 1;

%% adc data capture

for k = 1:captureRange
    release(rx)
    data = rx();
    rx_data(:,:,k) = data;
end

%% Stop TDD
tdd.EnableSyncSoft = false; % disable
tdd.Enable = false; % disable
tdd.FPGATDDEnginePolarity = false; % Turn off software control
tdd.Enable = true; %toggle to write property updates
tdd.Enable = false;

sray.TxRxSwitchControl(:) = {'spi'}; %spi: SPI TR Control, external: GPIO TR Control

%% release
release(rx)
release(tx);
release(tdd);

%% plot captured data
figure
title('Multi-Frame Rx Capture')
plot(real(rx_data(:,:,1)))
xlabel('Number of Samples')
ylabel('ADC Codes')

figure
title('Multi-Frame Rx Capture')
plot(timeRxSamples*1000,real(rx_data(:,:,2)))
xlabel('Time [ms]')
ylabel('ADC Codes')

