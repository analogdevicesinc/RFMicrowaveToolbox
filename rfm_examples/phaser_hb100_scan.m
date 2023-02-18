%% Phaser frequency sweep example
% This example assumes there is an emitter infront of Phaser within
% frequency range. The VCO is sweep to identify signal sources within range
% of the ADAR1000 supported bands
clc; clear all;

phaserURI = 'ip:phaser.local';
plutoURI = 'ip:pluto.local';
useOnboardPhaseTables = false;

%% Configure phaser
bf = adi.Phaser;
bf.uri = phaserURI;
bf.SkipInit = true; % Bypass writing all initial attributes to speed things up
bf();

% Put device in Rx mode
bf.TxRxSwitchControl = {'spi','spi'};
bf.Mode(:) = {'Disabled'};
bf.BeamMemEnable(:) = false;
bf.BiasMemEnable(:) = false;
bf.PolState(:) = false;
bf.PolSwitchEnable(:) = false;
bf.TRSwitchEnable(:) = true;
bf.ExternalTRPolarity(:) = true;

bf.RxVGAEnable(:) = true;
bf.RxVMEnable(:) = true;
bf.RxLNABiasCurrent(:) = 8;
bf.RxVGABiasCurrentVM(:) = 22;

% Self bias LNAs
bf.LNABiasOutEnable(:) = false;

% Fire them up
bf.RxPowerDown(:) = false;
bf.Mode(:) = {'Rx'};

%% Set up transceiver
rx = adi.AD9361.Rx('uri', plutoURI);
rx.EnabledChannels = [1,2];
rx.SamplesPerFrame = 1024;
rx.CenterFrequency = 2.0e9;
rx.kernelBuffersCount = 2; % Minimize delay in receive data
rx.GainControlModeChannel0 = 'manual';
rx.GainControlModeChannel1 = 'manual';
rx.GainChannel0 = 6;
rx.GainChannel1 = 6;
rx.SamplingRate = 30e6;

tx = adi.AD9361.Tx('uri', plutoURI);
tx.EnabledChannels = [1,2];
tx.AttenuationChannel0 = -89;
tx.AttenuationChannel1 = -89;
tx(randn(1024,2));

%% Set up PLL
bf.Frequency = 10e9 / 4;
BW = 500e6 / 4; num_steps = 1000;
bf.FrequencyDeviationRange = BW; % frequency deviation range in H1.  This is the total freq deviation of the complete freq ramp
bf.FrequencyDeviationStep = int16(BW / num_steps);  % frequency deviation step in Hz.  This is fDEV, in Hz.  Can be positive or negative
bf.RampMode = "disabled";
bf.DelayStartWord = 4095;
bf.DelayClockSource = "PFD";
bf.DelayStartEnable = false;  % delay start
bf.RampDelayEnable = false;  % delay between ramps.
bf.TriggerDelayEnable = false;  % triangle delay
bf.SingleFullTriangleEnable = false;  % full triangle enable/disable -- this is used with the single_ramp_burst mode
bf.TriggerEnable = false;  % start a ramp with TXdata

%% Flatten phaser phase/gain
bf.RxGain(:) = 64;
bf.RxAttn(:) = 0;
bf.RxPhase(:) = 0;
bf.RxLNAEnable(:) = true;
bf.LatchRxSettings();


%% Sweep frequencies
frequencies = 10e9:rx.SamplingRate*0.75:10.7e9;
amplitudes = zeros(length(frequencies)*rx.SamplesPerFrame,1);
frequencyIndexes  = zeros(length(frequencies)*rx.SamplesPerFrame,1);
capturesPerFrequency = 10;
index = 1;

for i = 1:length(frequencies)
    bf.Frequency = (frequencies(i) + rx.CenterFrequency)/4;
    % Remove old data
    for k = 1:4
        rx();
    end
    % Capture amplitudes in band
    spec_db = zeros(size(rx.SamplesPerFrame));
    for k = 1:capturesPerFrequency
        data = rx();
        data = sum(data,2);
        [spec_k, freqRangeRx] = spec_est(data, rx.SamplingRate, 2^11);
        spec_db = spec_db + spec_k;
    end
    amplitudes(index:index+rx.SamplesPerFrame-1) = spec_db./capturesPerFrequency;
    frequencyIndexes(index:index+rx.SamplesPerFrame-1) = freqRangeRx + frequencies(i);
    index = index + rx.SamplesPerFrame;
end


%% Plot
plot(frequencyIndexes./1e9, amplitudes); hold on;
xlabel('Frequency (GHz)'); ylabel('Amplitude (dB)');
grid;
[Peak, PeakIdx] = max(amplitudes);
text(frequencyIndexes(PeakIdx+200)./1e9, Peak-4, sprintf('Peak = %6.3f GHz', frequencyIndexes(PeakIdx)/1e9))
hold off;

%% Helpers
function [spec_db, freqRangeRx] = spec_est(x, fs, fullscale)

Nfft = length( x );
win = kaiser(Nfft,100);
win = win/sum(win);
win = win*Nfft;
x = x.*win;

spec = fft( x ) / Nfft;
spec = fftshift(spec);

spec_db = 20*log10(abs(spec)/fullscale+10^-20);

df = fs/Nfft;  freqRangeRx = (-fs/2:df:fs/2-df).';
% plot(freqRangeRx,fftshift(spec_db));
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dBFS)');
end