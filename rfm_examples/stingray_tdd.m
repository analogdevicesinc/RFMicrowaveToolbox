clear all; clc; close all;

uri = 'ip:192.168.1.155';

interFreq = 1e9; %Tx NCO Frequency & Unfolded Rx NCO Frequency [Hz]
fs_RxTxIQ = 250e6; %IQ Sample Rate [Hz]
basebandFreq = fs_RxTxIQ; %Baseband Frequency [Hz]

%% Setup TDD first
tdd = adi.StingrayTDD;
tdd.uri = uri;
% Startup and connect
tdd.SkipInit = true;
tdd();
tdd.Enable = false;
tdd.StartupDelayMilliseconds = 0;

% Invert TDD control to allow pure software control
tdd.FPGATDDEnginePolarity = true;
tdd.FPGATDDEngineOffStartMilliseconds = 0;
tdd.FPGATDDEngineOnStartMilliseconds = 0;
tdd.FPGATDDEngineEnable = true;

% Configure top level engine
samplesPerFrame = 2^12;
frameLengthMS = samplesPerFrame/fs_RxTxIQ*1000;
tdd.FrameLengthMilliseconds = frameLengthMS;

% Configure component channels
onTime = 0; offTime = frameLengthMS - 0.1;
tdd.FPGATxOffloadSyncOffStartMilliseconds = offTime;
tdd.FPGATxOffloadSyncOnStartMilliseconds = onTime;
tdd.FPGATxOffloadSyncEnable = true;

tdd.FPGARxOffloadSyncOffStartMilliseconds = offTime;
tdd.FPGARxOffloadSyncOnStartMilliseconds = onTime;
tdd.FPGARxOffloadSyncEnable = true;

tdd.RxMxFEOffStartMilliseconds = offTime;
tdd.RxMxFEOnStartMilliseconds = onTime;
tdd.RxMxFEEnable = true;

tdd.TxMxFEOffStartMilliseconds = offTime;
tdd.TxMxFEOnStartMilliseconds = onTime;
tdd.TxMxFEEnable = true;

tdd.Enable = true; % fire up the TDD engine

%% Setup AD9081 Tx & Rx
tx = adi.AD9081.Tx;
tx.uri = uri;
tx.EnabledChannels = 1;
tx.MainNCOFrequencies = ones(1,4)*interFreq;
tx.MainNCOPhases = zeros(1,4);
tx.ChannelNCOFrequencies = zeros(1,4);
tx.ChannelNCOPhases = zeros(1,4);

tx.DataSource = 'DMA';
tx.EnableCyclicBuffers = true;
tx.DDROffloadEnable = true;
tx.kernelBuffersCount = 1;

% Generate a ramp that fits in the frame size
assert(samplesPerFrame < 2^15, 'Frame size too large for ramp generation');
ramp = 0:(samplesPerFrame-1);

tx(ramp.');
tx.SkipInit = true; % For now on do not touch properties

%% Setup Rx
rx = adi.AD9081.Rx;
rx.uri = uri;
rx.EnabledChannels = 1;
rx.SamplesPerFrame = samplesPerFrame*2;
rx.MainNCOFrequencies = ones(1,4)*interFreq;
rx.ChannelNCOFrequencies = zeros(1,4);
rx.MainNCOPhases = zeros(1,4);
rx.ChannelNCOPhases = zeros(1,4);

figure; hold on;

for i=1:10

    tdd.EnableSyncSoft = false;

    tx.release();

    tdd.Enable = false;

    % Clean
    rx();
    rx.SkipInit = true; % Skip prop retuning

    tdd.Enable = true;

    tx.EnableCyclicBuffers = true;
    tx.DDROffloadEnable = true;
    tx(ramp.');

    % Wait for timeout
    [~, valid] = rx();
    assert(~valid);

    tdd.EnableSyncSoft = true;

    % Pull filled buffer
    data = rx();

    if i == 1
        continue;
    end

    d = diff(real(data));
    [~,index] = max(abs(data));
    fprintf("Transition at %d (Iteration %d)\n", index, i);

    plot(real(data));
    drawnow;
    pause(0.1);

end
hold off;

rx.release();
tx.release();
tdd.release();
