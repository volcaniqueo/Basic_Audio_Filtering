% Load the audio file
filename = 'audio.wav';
[y, Fs] = audioread(filename);

% Define filter coefficients
% Low-pass filter for drum kick (cutoff frequency: 500 Hz)
% 'low' is default with this function signature
lowpass_coeff = fir1(128, 500/(Fs/2));

% Band-pass filter for piano (frequency range: 500-4000 Hz)
% 'bandpass' is default with this function signature
bandpass_coeff = fir1(128, [500/(Fs/2), 4000/(Fs/2)]);

% High-pass filter for cymbals (cutoff frequency: 4000 Hz)
% 'high' should be explicitly written with this function signature
highpass_coeff = fir1(128, 4000/(Fs/2), 'high');

% Apply the filters to separate the audio tracks
kick_track = filter(lowpass_coeff, 1, y);
piano_track = filter(bandpass_coeff, 1, y);
% Apply band-pass filter twice for piano
piano_track = filter(bandpass_coeff, 1, piano_track); 
cymbal_track = filter(highpass_coeff, 1, y);

% Normalize the tracks to avoid clipping
% Without normalization we get a warning
kick_track = kick_track / max(abs(kick_track));
piano_track = piano_track / max(abs(piano_track));
cymbal_track = cymbal_track / max(abs(cymbal_track));

% Save the separated tracks as audio files
audiowrite('kick.wav', kick_track, Fs);
audiowrite('piano.wav', piano_track, Fs);
audiowrite('cymbal.wav', cymbal_track, Fs);

% Plot the magnitude of the frequency response of each filter
N = 512; % Number of frequency points for the plot; higher N, results smoother plots

% Frequency response of low-pass filter for drum kick
figure;
freqz(lowpass_coeff, 1, N, Fs);
title('Magnitude Frequency Response - Low-pass Filter (Drum Kick)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Frequency response of band-pass filter for piano
figure;
freqz(bandpass_coeff, 1, N, Fs);
title('Magnitude Frequency Response - Band-pass Filter (Piano)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Frequency response of high-pass filter for cymbals
figure;
freqz(highpass_coeff, 1, N, Fs);
title('Magnitude Frequency Response - High-pass Filter (Cymbals)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');


% Create waveform plots of each audio track
t = (0:length(y)-1) / Fs; % Time axis

figure;
subplot(4,1,1);
plot(t, y);
title('Original Audio');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4,1,2);
plot(t, kick_track);
title('Drum Kick Track');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4,1,3);
plot(t, piano_track);
title('Piano Track');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4,1,4);
plot(t, cymbal_track);
title('Cymbal Track');
xlabel('Time (s)');
ylabel('Amplitude');
