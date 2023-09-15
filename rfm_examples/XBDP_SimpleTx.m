%% XBDP_SimpleTX.m 
% Description: This script is to be used with the Analog Devices X-Band 
% Development Platform to demonstrate MATLAB control of the system. 
% It allows the user to configure the Tx aspects of the system and then 
% load in transmit data for all channels on the system. 
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

%% Config Dev Kit
uri = 'ip:192.168.1.101';
amplitude = 2^15*db2mag(-6); %Tx Baseband Amplitude [dBFS]
interFreq = 4.5e9; %Tx NCO Frequency [Hz]

fs_TxIQ = 250e6; %Tx Decimated IQ Sample Rate [Hz]
periods = 32; %Desired Number Of Periods For Tx Signal
basebandFreq = fs_TxIQ/periods; %Baseband Frequency [Hz]

%Setup AD9081 Tx
tx = adi.AD9081.Tx;
tx.uri = uri;
tx.EnabledChannels = [1 2 3 4];%Enabled Tx Channels, Only Needed for DMA

tx.SamplesPerFrame = 2^10; %Number Of Samples
tx.NCOEnables = ones(1,numel(tx.EnabledChannels));
tx.ChannelNCOGainScales = ones(1,numel(tx.EnabledChannels)).*0.5; %MxFE0 Digital Gain Code

%DMA Configuration
tx.DataSource = 'DMA'; %'DMA' or 'DDS'
tx.EnableCyclicBuffers = 1; %0: Don't Cycle Tx Waveform, 1: Cycle Tx Waveform

swv1 = dsp.SineWave(amplitude, basebandFreq);
swv1.ComplexOutput = true;
swv1.SamplesPerFrame = tx.SamplesPerFrame;
swv1.SampleRate = fs_TxIQ;
y = swv1();
waveform = ones(tx.SamplesPerFrame,numel(tx.EnabledChannels)).*y;

release(tx)
tx(waveform);

tx.MainNCOFrequencies = ones(1,numel(tx.EnabledChannels))*interFreq; %NCO Frequency
tx.MainNCOPhases = zeros(1,numel(tx.EnabledChannels)); %NCO Phase

% Setup ADAR1000EVAL1Z in Tx Mode
sray = adi.Stingray;
sray.uri = uri;
sray.Mode(:) = {'Tx'}; %set mode, 'Rx', 'Tx, 'Disabled'
txPhaseCalOffsets = zeros(size(sray.TxGain));
sray.TxAttn(:) = 1; %1: Attenuation Off, 0: Attenuation On
sray.SteerTx(0,0,txPhaseCalOffsets); %Broadside
sray.TxGain(:) = 127; %127: Highest Gain, 0: Lowest Gain, Decimal Value
sray.LatchTxSettings; %Latch settings to devices
sray(); %Stingray Constructor

%Setup ADXUD1AEBZ, %Tx Mode
sray.TXRX0 = 1; %0: RX, 1: TX
sray.TXRX1 = 1;
sray.TXRX2 = 1;
sray.TXRX3 = 1;
sray.RxGainMode = 0; %0: Low Gain, 1: High Gain, RX Mode only
sray.ADF4371Frequency = 14.5e9; %program if using on-board LO PLL
sray.PllOutputSel = 1; %1: ADF4371 RF1 (8 GHz to 16 GHz), 0: ADF4371 RF2 (16 GHz to 32 GHz)

sray.PABiasOn(:) = -1.06;
sray.TxPAEnable(:) = true;
sray.TxPowerDown(:) = false; %Enable all channels for TX

detect = sray.LTC2314RFPower; %reads detected power (dBm) for J9 Input

sray.TxPowerDown(:) = true; %Disable all channels for TX