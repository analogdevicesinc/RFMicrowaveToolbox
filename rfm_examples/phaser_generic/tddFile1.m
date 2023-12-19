%% 
clear all;

% Setup the pluto
plutoURI = 'ip:192.168.2.1';
warning("off")
rx = adi.AD9361.Rx('uri', plutoURI);
rx.EnabledChannels = [1,2];
rx.SamplesPerFrame = 2^20;
rx.CenterFrequency = 2e9;
rx.kernelBuffersCount = 2; % Minimize delay in receive data
rx.GainControlModeChannel0 = 'manual';
rx.GainControlModeChannel1 = 'manual';
rx.GainChannel0 = 6;
rx.GainChannel1 = 6;
rx.SamplingRate = 3e6;

tx = adi.AD9361.Tx('uri', plutoURI);
tx.EnabledChannels = [1,2];
tx.CenterFrequency = rx.CenterFrequency;
tx.AttenuationChannel0 = -3;
tx.AttenuationChannel1 = -3;
tx.SamplesPerFrame = 2^20;
tx.EnableCyclicBuffers =true;
tx.DataSource = "DMA";

sw = dsp.SineWave;
sw.Amplitude = 2^15;
sw.Frequency = 0.1e6;
sw.ComplexOutput = true;
sw.SampleRate = rx.SamplingRate;
sw.SamplesPerFrame = 50e3;  %1e6 samples at 3MSPS is 330ms of time
startTx=sw();
sw.Amplitude=2^2;
endTx=sw();
totalTx=cat(1,startTx,endTx,startTx,startTx,endTx,endTx,startTx,startTx,startTx,startTx,endTx, endTx, startTx,endTx,startTx,startTx,endTx,endTx,startTx,startTx);
txWaveform = [0.9*totalTx 0.9*totalTx]; 
tx(txWaveform);

warning("on")

%% Setup the phaser
fc_hb100 = 10.145e9;
phaserURI = 'ip:phaser.local';
bf = setupPhaser(rx,phaserURI,fc_hb100);
bf.RxPowerDown(:) = 0;
bf.RxGain(:) = 127;
bf.EnablePLL = true;
bf.EnableTxPLL = true;
bf.EnableOut1 = false;

%% Setup the ADF4159
%bf.Frequency = (fc_hb100 + rx.CenterFrequency) / 4;
bf.Frequency = (12e9) / 4;
BW = 490e6 / 4; 
num_steps = 2^9;
ramp_time = 2^10;   % total ramp time (in us) of the complete frequency ramp
bf.FrequencyDeviationRange = BW; % frequency deviation range in H1.  This is the total freq deviation of the complete freq ramp
bf.FrequencyDeviationStep = ((BW) / num_steps);  % frequency deviation step in Hz.  This is fDEV, in Hz.  Can be positive or negative
bf.FrequencyDeviationTime = ramp_time;
bf.RampMode = "single_sawtooth_burst";
bf.TriggerEnable = true;  % start a ramp with TXdata

%% Setup the TDD engine
bf_TDD = adi.PhaserTDD('uri', plutoURI);
bf_TDD();
bf_TDD.Enable = 0;   % TDD must be disabled before changing properties
bf_TDD.EnSyncExternal = 1;
bf_TDD.StartupDelay = 5;
bf_TDD.SyncReset = 0;
bf_TDD.FrameLength = 2;  %frame length in ms
bf_TDD.BurstCount = 200;
bf_TDD.Ch0Enable = 1;
bf_TDD.Ch0Polarity = 0;
bf_TDD.Ch0On = 0.1;
bf_TDD.Ch0Off = 0.2;
bf_TDD.Ch1Enable = 1;
bf_TDD.Ch1Polarity = 0;
bf_TDD.Ch1On = 0;
bf_TDD.Ch1Off = 0.1;
bf_TDD.Ch2Enable = 0;
bf_TDD.Ch2Polarity = 1;
bf_TDD.Ch2On = 0;
bf_TDD.Ch2Off = bf_TDD.FrameLength;
bf_TDD.Enable = 1;

bf_TDD.Enable = 0;
tx(txWaveform);
bf_TDD.Ch2Enable = 1;
bf_TDD.Enable = 1;

%% Trigger TDD
%bf_TDD.SyncSoft = 1;

for i=1:2
    %bf_TDD.Enable = 0;
    tx(txWaveform);
    %bf_TDD.Ch2Enable = 1;
    %bf_TDD.Enable = 1;
    bf.Burst=false;bf.Burst=true;bf.Burst=false;
    data = rx();
end

close all;
figure;
hold all;
axis([0 length(txWaveform) -1000 1000])
plot(real(txWaveform(:,1)))
plot(real(data(:,1)))
