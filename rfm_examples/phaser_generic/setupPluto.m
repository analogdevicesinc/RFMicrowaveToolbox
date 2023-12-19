rx = adi.AD9361.Rx('uri', plutoURI);
rx.EnabledChannels = [1,2];
rx.SamplesPerFrame = 1024;
rx.CenterFrequency = 2.e9;
rx.kernelBuffersCount = 2; % Minimize delay in receive data
rx.GainControlModeChannel0 = 'manual';
rx.GainControlModeChannel1 = 'manual';
rx.GainChannel0 = 6;
rx.GainChannel1 = 6;
rx.SamplingRate = 30e6;
rx();

tx = adi.AD9361.Tx('uri', plutoURI);
tx.EnabledChannels = [1,2];
tx.CenterFrequency = rx.CenterFrequency+2e6;
tx.AttenuationChannel0 = -89;
tx.AttenuationChannel1 = -89;