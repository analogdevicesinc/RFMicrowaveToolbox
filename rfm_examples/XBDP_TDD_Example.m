%% XBDP_TDD_Example.m 
% Description: This script is to be used with the Analog Devices X-Band 
% Development Platform to demonstrate MATLAB control of the system. 
% It allows the user to configure the Rx/Tx aspects of the system, then 
% excercise the TDD core for pulsed radar evaluations. 
% This script requires the use of the Analog Devices, Inc. High
% Speed Converter Toolbox and RF & Microwave Toolbox
%
% Author: Sam Ringwood
% Date: February 2023

% Gain Access to the Analog Devices, Inc. High Speed Converter Toolbox at:
% https://github.com/analogdevicesinc/HighSpeedConverterToolbox

% Gain Access to the Analog Devices, Inc. RF & Microwave Toolbox at:
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
dac_map = [4 3 2 1]; %DAC map to subarray
dac_ref = 4; %DAC reference channel
adc_map = [4 2 1 3]; %ADC map to subarray
adc_ref = 4; %ADC reference channel

%% Config Dev Platform

uri = 'ip:192.168.1.211';

interFreq = 4.5e9; %Tx NCO Frequency & Unfolded Rx NCO Frequency [Hz]

fs_RxTxIQ = 250e6; %IQ Sample Rate [Hz]
periods = 32; %Desired Number Of Periods For Tx Signal
basebandFreq = fs_RxTxIQ/periods; %Baseband Frequency [Hz]

%Setup AD9081 Tx & Rx
tx = adi.AD9081.Tx;
rx = adi.AD9081.Rx;
tx.uri = uri;
rx.uri = uri;

tx.EnabledChannels = [1 2 3 4];%Enabled Tx Channels, Only Needed for DMA
rx.EnabledChannels = [1 2 3 4];%Enabled Rx Channels

tx.SamplesPerFrame = 2^12; %Number Of Samples: 4096
rx.SamplesPerFrame = 2^12; %Number Of Samples: 4096

tx.NCOEnables = ones(1,4);
tx.ChannelNCOGainScales = ones(1,4).*0.5; %MxFE0 Digital Gain Code

tx.MainNCOFrequencies = ones(1,4)*interFreq; %NCO Frequency
rx.MainNCOFrequencies = ones(1,4)*550e6; %NCO Frequency

tx.MainNCOPhases = zeros(1,4); %NCO Phase
rx.MainNCOPhases = zeros(1,4); %NCO Phase

tx.DataSource = 'DMA'; %'DMA' or 'DDS'
tx.EnableCyclicBuffers = 1; %0: Don't Cycle Tx Waveform, 1: Cycle Tx Waveform

%create Tx waveform
A = 2^15*db2mag(-6); %Tx Baseband Amplitude [dBFS]
B = fs_RxTxIQ/2.5;
N = tx.SamplesPerFrame;
T = N/fs_RxTxIQ;
t = linspace(-T/2,T/2,N);
txSig = sinc(B*t);
txSig2 = A*exp(2*-1i*pi*B*t);

%CW Waveform
swv1 = dsp.SineWave(A, basebandFreq);
swv1.ComplexOutput = true;
swv1.SamplesPerFrame = tx.SamplesPerFrame;
swv1.SampleRate = fs_RxTxIQ;
y = swv1();
waveform = ones(tx.SamplesPerFrame,numel(tx.EnabledChannels)).*y;

release(tx)
tx(waveform); %send Tx data

% Setup ADAR1000EVAL1Z in Tx Mode
sray = adi.Stingray;
sray.uri = uri;
sray.Mode(:) = {'Tx'}; %set mode, 'Rx', 'Tx, 'Disabled'
sray.TxAttn(:) = true; %1: Attenuation Off, 0: Attenuation On
sray.TxGain(:) = 127; %127: Highest Gain, 0: Lowest Gain
sray.LatchTxSettings; %Latch settings to devices
% sray.TRSwitchEnable(:) = false; %True: SPI control, False: TR Pin GPIO Control
sray(); %Stingray Constructor

%Setup ADXUD1AEBZ, %Tx Mode
sray.TXRX0 = 1; %0: RX, 1: TX
sray.TXRX1 = 1;
sray.TXRX2 = 1;
sray.TXRX3 = 1;
sray.RxGainMode = 0; %0: Low Gain, 1: High Gain, RX Mode only

sray.PABiasOn(:) = -1.06;
sray.TxPAEnable(:) = true;
sray.TxPowerDown(1) = false; %Enable channel 1 for TX
%% setup TDD
sray.TxRxSwitchControl(:) = {'external'}; %spi: SPI TR Control, external: GPIO TR Control
 
sray.FrameLength = 1; %frame length in ms
sray.BurstCount = 0; %number of frames after enable. 0 equals infinite repeat
sray.DMAGateingMode = 3;% 0 - none, 1 - rx_only, 2 - tx_only, 3 - rx_tx
sray.Secondary = false;

sray.TxVCOon = [0 0]; %Stingray/Xud1a TR Frame Start
sray.TxVCOoff = [100e-3 0]; %Stingray/Xud1a TR Frame Stop
sray.TxOn = [0 0] ; %MxFE TX Enable Frame Start
sray.TxOff = [100e-3 0]; %MxFE TX Enable Frame Stop
sray.TxDPon = [0 0] ; %MxFE TX Datapath Frame Start
sray.TxDPoff = [100e-3 0] ; %MxFE TX Datapath Frame Stop
sray.RxOn = [101e-5 0]; %MxFE RX Enable Frame Start
sray.RxOff = [1 0]; %MxFE RX Enable Frame Stop
sray.RxDPon = [101e-5 0] ; %MxFE RX Datapath Frame Start
sray.RxDPoff = [1 0] ; %MxFE RX Datapath Frame Stop

%units are in ms. Settings configure a 1 kHz PRF with 10% duty cycle
sray.EnableMode = 3;% 1 - rx_only, 2 - tx_only, 3 - rx_tx
sray.Enable = 1; %enable TDD Core