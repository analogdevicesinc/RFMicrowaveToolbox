%% XMW 2-24GHz Platform Simple TX
% Description: This script is to be used with the Analog Devices 2-24GHz
% XMW TX Platform to demonstrate MATLAB control of the system.
% It allows the user to configure the TX aspects of the system and then
% transmit.
% This script requires the use of the Analog Devices, Inc. RF Microwave Toolbox
% and the Analog Devices, Inc. High Speed Converter Toolbox.
%
% Author: Reema Saleem
% Date: 8/2023
%
% Gain Access to the Analog Devices, Inc. High Speed Converter Toolbox at:
% https://github.com/analogdevicesinc/HighSpeedConverterToolbox
%
% Gain Access to the Analog Devices, Inc. RF Microwave Toolbox at:
% https://github.com/analogdevicesinc/RFMicrowaveToolbox

clear all, close all, clc

%% Set up AD9082 TX
% Get Device configuration automatically
tx = adi.AD9081.Tx('uri',uri);
[cdc, fdc, dc] = tx.GetDataPathConfiguration();
tx = adi.AD9081.Tx(...
	'uri',uri,...
	'num_data_channels', dc, ...
	'num_coarse_attr_channels', cdc, ...
	'num_fine_attr_channels', fdc);
tx.DataSource = 'DDS';
tx.NCOEnables = [1,0];
tx.ChannelNCOFrequencies = [0,0];
tx.MainNCOFrequencies = [4e9,0];
toneFreq = 0.5e9;
tx.DDSFrequencies = [toneFreq,0;0,0];
tx.DDSScales = [1,0;0,0];
tx.DDSPhases = [0,0;0,0];
tx();

%% Set up XMW TX Platform
uri = 'ip:analog.local';
rf_system = adi.XMW_TX_Platform;
rf_system.uri = uri;
rf_system();

%% Configure RF properties
rf_system.if_attenuation_decimal = 0;
rf_system.output_freq_MHz = 12500;

pause(1);
tx.release();
