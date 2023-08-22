%% XMW 2-24GHz Platform Simple RX
% Description: This script is to be used with the Analog Devices 2-24GHz
% XMW RX Platform to demonstrate MATLAB control of the system.
% It allows the user to configure the Rx aspects of the system and then
% capture receive data for all channels on the system.
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

%% Set up XMW RX Platform
uri = 'ip:analog.local';
rf_system = adi.XMW_RX_Platform;
rf_system.uri = uri;
rf_system();

%% Configure RF properties
rf_system.input_attenuation_dB = 0;
rf_system.if_attenuation_decimal = 0;
rf_system.input_mode = 1;
rf_system.input_freq_MHz = 12500;

%% Set up AD9082 RX
% Get Device configuration automatically
rx = adi.AD9081.Rx('uri',uri);
[cdc, fdc, dc] = rx.GetDataPathConfiguration();
rx = adi.AD9081.Rx(...
	'uri',uri,...
	'num_data_channels', dc, ...
	'num_coarse_attr_channels', cdc, ...
	'num_fine_attr_channels', fdc);
rx.MainNCOFrequencies = ones(1,2)*1000e6;

%% RX run
for k=1:10
	valid = false;
	while ~valid
		[out, valid] = rx();
	end
end
fs = rx.SamplingRate;
rx.release();

%% Plot
nSamp = length(out);
FFTRxData  = fftshift(10*log10(abs(fft(out))));
df = fs/nSamp;
freqRangeRx = (-nSamp/2:nSamp/2-1)*double(df/1000);
plot(freqRangeRx, FFTRxData);
xlabel('Frequency (kHz)');
ylabel('Amplitude (dB)');
grid on;
