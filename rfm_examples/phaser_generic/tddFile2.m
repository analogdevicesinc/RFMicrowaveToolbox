%% 
clear all;

% Setup the pluto
plutoURI = 'ip:192.168.2.1';
warning("off")
rx = setupPluto(plutoURI);
warning("on")

% Setup the phaser
fc_hb100 = 10.145e9;
phaserURI = 'ip:phaser.local';
bf = setupPhaser(rx,phaserURI,fc_hb100);
bf.RxPowerDown(:) = 0;
bf.RxGain(:) = 127;

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
bf.Burst=false;bf.Burst=true;bf.Burst=false;

%% Setup the TDD engine
bf_TDD = adi.PhaserTDD('uri', plutoURI);
bf_TDD();
bf_TDD.Enable = 0;   % TDD must be disabled before changing properties
bf_TDD.EnSyncExternal = 1;
bf_TDD.StartupDelay = 5;
bf_TDD.SyncReset = 0;
bf_TDD.FrameLength = 2.5;  %frame length in ms
bf_TDD.BurstCount = 2;
bf_TDD.Ch0Enable = 1;
bf_TDD.Ch0Polarity = 0;
bf_TDD.Ch0On = 0.1;
bf_TDD.Ch0Off = 1;
bf_TDD.Ch1Enable = 1;
bf_TDD.Ch1Polarity = 0;
bf_TDD.Ch1On = 0;
bf_TDD.Ch1Off = .001;
bf_TDD.Enable = 1;

%% Trigger TDD
%bf_TDD.SyncSoft = 1;
bf.Burst=false;bf.Burst=true;bf.Burst=false;

