%% Phaser beamsweep example
% This example assumes there is an emitter infront of Phaser within
% frequency range. The phases will be swept and peaks will be determined at
% each phase perspective. A peak should appear at the perspective the
% location of the emitter
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
bf.Mode(:) = {'Rx'};
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
bf.RxEnable(:) = true;

%% Set up transceiver
rx = adi.AD9361.Rx('uri', plutoURI);
rx.EnabledChannels = [1,2];
rx.SamplesPerFrame = 1024;
rx.kernelBuffersCount = 2; % Minimize delay in receive data
rx(); % eat initialization overhead

%% Set up PLL
bf.Frequency = rx.CenterFrequency / 4;
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

%% Cycle across aperture
% Calculate phases to sweep across
PhaseResolutionBits = 7;
averages = 1;
pCal = zeros(1,8); % Manual offsets
gainCal = [0.71881048633515, 0.6893103957566313, 0.7351724568594444, ...
    0.6505813381466207, 0.86642335445822, 1.0, 0.9727178548992017, ...
    0.9590266348437717];
phaseCal = [0, -2.8125, -11.25, -8.4375, 22.5, 30.9375, 59.0625, 53.4375];

phase_step_size = 360 / (2 ^ PhaseResolutionBits);
phase_limit = double(int16(225 / phase_step_size)) * phase_step_size + phase_step_size;
phases = double(-phase_limit:phase_step_size:phase_limit);

magnitudes = zeros(size(phases));

% Run
for k = 1:10
    for phaseIndx = 1:length(phases)
        setPhase(bf, phases(phaseIndx), phase_step_size, phaseCal, pCal,...
            useOnboardPhaseTables);
        magnitudes(phaseIndx) = getFFTData(rx, averages);
    end
    plot(phases, magnitudes);
    xlabel('Phase (Degrees)');ylabel('Magnitude (dB)');grid on;
    drawnow;
    pause(0.01);
end


%% Set phase of beamformers for perspective
function setPhase(bf, deltas, stepSize, inPhases, pCal, useOnboardPhaseTables)
rx_phase = round(deltas .* (0:7) ./ stepSize) * stepSize + inPhases + pCal;
rx_phase = mod(rx_phase,360);

if ~useOnboardPhaseTables
    bf.RxPhase(:) = rx_phase;
    bf.BeamMemEnable(:) = false;
    bf.LatchRxSettings();
else
    error('Driver lookup currently broken');
%     rx_gains = bf.getAllChipsChannelAttribute('hardwaregain', false, 'double');
%     c = {};
%     beam_pos = 0;
%     atten = 0;
%     for k=1:length(rx_phase)
%         [i,q] = phaseLookup(rx_phase(k));
%         c{k} = sprintf('%d, %d, %d, %d', beam_pos, atten, int16(rx_gains(k)), int16(rx_phase(k)) );
% 
%     end
%     bf.setAllChipsChannelAttribute(c, 'beam_pos_save', false, 'raw');
%     bf.BeamMemEnable(:) = true;
%     bf.RxBeamState(:) = beam_pos;
end

end

%% Helper functions

function peakdBFS = getFFTData(rx, averages)

beam0_phase = 0;
beam1_phase = 0;
s = 0;

for a = 1:averages
    rx(); data = rx(); % Throw away first buffer since its old
    c1 = ifft(fft(data(:,1)) .* exp(1j * beam0_phase));
    c2 = ifft(fft(data(:,2)) .* exp(1j * beam1_phase));

    c = c1 + c2;

    % Get max
    maxVal = max(abs(c));
    s_dbfs_sum = 20 * log10(maxVal / (2 ^ 11));
    s = s + s_dbfs_sum;
end

peakdBFS = s/averages;

end


function [i,q] = phaseLookup(phase)

[phases, i, q] = importfile("adar1000_phase_table.csv", [1, Inf]);

[~,indx] = min(abs(phases-phase));

i = i(indx);
q = q(indx);

end