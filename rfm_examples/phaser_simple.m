clc;clear all;
bf = adi.Phaser;
%
bf.uri = 'ip:phaser.local';
bf.SkipInit = true;
% %
bf();

bf.Mode(:) = {'Rx'};
bf.BeamMemEnable(:) = false;
bf.BiasMemEnable(:) = false;
bf.PolState(:) = false;
bf.PolSwitchEnable(:) = false;
% tr_source = {'spi','spi','spi','spi'};
tr_source = [0,0,0,0];
bf.setAllChipsDeviceAttributeRAW('tr_source', tr_source, true);
% tr_spi = {'rx','rx','rx','rx'};
tr_spi = [0,0,0,0];
bf.setAllChipsDeviceAttributeRAW('tr_spi', tr_spi, true);
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

%% Program mixer
% bf.ADF4371Frequency = 10.156e9;

%% Set up transceiver
rx = adi.AD9361.Rx('uri','ip:192.168.2.1');
rx.EnabledChannels = [1,2];
rx.SamplesPerFrame = 1024;
rx.kernelBuffersCount = 2;
data = rx(); % eat initialization overhead


PhaseResolutionBits = 7;
gainCal = [0.71881048633515, 0.6893103957566313, 0.7351724568594444, ...
    0.6505813381466207, 0.86642335445822, 1.0, 0.9727178548992017, ...
    0.9590266348437717];
phaseCal = [0, -2.8125, -11.25, -8.4375, 22.5, 30.9375, 59.0625, 53.4375];

phase_step_size = 360 / (2 ^ PhaseResolutionBits);
phase_limit = double(int16(225 / phase_step_size)) * phase_step_size + phase_step_size;
phases = double(-phase_limit:phase_step_size:phase_limit);

pCal = zeros(1,8);

averages = 1;
magnitudes = zeros(size(phases));

for k = 1:10
    for phaseIndx = 1:length(phases)
        setPhase(bf, phases(phaseIndx), phase_step_size, phaseCal, pCal);
        magnitudes(phaseIndx) = getFFTData(rx, averages);
    end
%     break
    disp('Update');
    plot(phases, magnitudes);
    drawnow;
    pause(0.01);
end


%%

function setPhase(bf, deltas, stepSize, inPhases, pCal)
rx_phase = round(deltas .* (0:7) ./ stepSize) * stepSize + inPhases + pCal;
rx_phase = mod(rx_phase,360);

bf.RxPhase(:) = rx_phase;
bf.BeamMemEnable(:) = false;
bf.LatchRxSettings();

% rx_gains = bf.getAllChipsChannelAttribute('hardwaregain', false, 'double');
% c = {};
% beam_pos = 0;
% atten = 0;
% for k=1:length(rx_phase)
%     [i,q] = phase_lookup(rx_phase(k));
%     c{k} = sprintf('%d, %d, %d, %d', beam_pos, atten, int16(rx_gains(k)), int16(rx_phase(k)) );
% 
% end
% bf.setAllChipsChannelAttribute(c, 'beam_pos_save', false, 'raw');
% bf.BeamMemEnable(:) = true;
% bf.RxBeamState(:) = beam_pos;


end

%%

function peakdBFS = getFFTData(rx, averages)

beam0_phase = 0;
beam1_phase = 0;
s = 0;

for a = 1:averages
    data = rx(); data = rx();
    c1 = ifft(fft(data(:,1)) .* exp(1j * beam0_phase));
    c2 = ifft(fft(data(:,2)) .* exp(1j * beam1_phase));

    c = c1 + c2;

    % Get max
    maxVal = max(abs(c));
    s_dbfs_sum = 20 * log10(maxVal / (2 ^ 11));
    s = s + s_dbfs_sum;

end
peakdBFS = s / averages;

end


function [i,q] = phase_lookup(phase)

    [phases, i, q] = importfile("/tmp/RFMicrowaveToolbox/+adi/+internal/adar1000_phase_table.csv", [1, Inf]);

    [~,indx] = min(abs(phases-phase));

    i = i(indx);
    q = q(indx);

end