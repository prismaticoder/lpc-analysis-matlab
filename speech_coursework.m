% Step 1: Read the Sample File
[speechSignal, fs] = audioread('heed_m.wav');  % Replace with your file
disp('Sample Loaded');

% % Step 2: Pick a Window/Segment from the Speech Signal
% windowSize = round(0.02 * fs);   % 20 ms window (adjust this as needed)
% segment = speechSignal(1:windowSize);

% Step 2: Define the duration of the segment
segmentDurationMs = 100; % Duration of the segment in milliseconds
segmentDurationSamples = round((segmentDurationMs / 1000) * fs); % Convert to samples

% Step 3: Choose a starting point for the segment
startSample = 50; % Set this to a desired starting point (in samples)

% Step 4: Extract the segment
segment = speechSignal(startSample:startSample + segmentDurationSamples - 1);

% Step 2: Pick a Window/Segment from the Speech Signal
% totalSamples = length(speechSignal);              % Get the total number of samples
% windowSize = round(0.1 * fs);                    % 20 ms window
% midPoint = round(totalSamples / 3);                % Find the midpoint of the signal
% startIndex = max(1, midPoint - round(windowSize / 3));  % Start around the middle
% segment = speechSignal(startIndex:startIndex + windowSize - 1);  % Extract the segment

% Step 3: Plot the Segment
% Generate the time vector for the segment
segment_time = (startSample:startSample + segmentDurationSamples - 1) / fs;  % Time vector for the segment

% Create the plot
% figure;  % Open a new figure window
% plot(segment_time, segment);
% xlabel('Time (seconds)');  % Label x-axis
% ylabel('Amplitude');        % Label y-axis
% title('Segment of Speech Signal');  % Title for the plot
% grid on;                   % Enable grid

% Estimate the LPC coefficients
order = 20; % Set the model order
a_k = lpc(segment, order);

% Plot the frequency response of the LPC filter
[H, f] = freqz(1, a_k);
% f = w * windowSize / (2 * pi);
% figure;
% plot(f, 20 * log10(abs(h)));
% hold on;
% % Plot the amplitude spectrum of the speech segment
% spectrum = fft(segment);
% spectrum_dB = 20 * log10(abs(spectrum));
% plot(f, spectrum_dB(1:length(windowSize)));
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');
% legend('LPC Filter Response', 'Speech Amplitude Spectrum');

% Plot the magnitude response
% figure;
% subplot(2, 1, 1);
% plot(f/pi, 20*log10(abs(H))); % Convert to dB
% xlabel('Normalized Frequency (\times \pi rad/sample)');
% ylabel('Magnitude (dB)');
% title('Magnitude Response');
% grid on;

% % Plot the phase response
% subplot(2, 1, 2);
% plot(f/pi, angle(H)); % Phase response
% xlabel('Normalized Frequency (\times \pi rad/sample)');
% ylabel('Phase (radians)');
% title('Phase Response');
% grid on;

% Estimate the first three formant frequencies
% formants = 3; % Find the peaks in the LPC filter response
% formant1 = formants(1);
% formant2 = formants(2);
% formant3 = formants(3);

% Step 7: Find the Poles (Roots of the Denominator)
% poles = roots(a);
% disp('Poles found');

% Step 8: Plot the Pole-Zero Diagram
% figure;
% zplane(1, A_k);  % Pole-zero plot
% title('Pole-Zero Plot');
% disp('Pole-zero plot displayed');
%
% % Step 9: Calculate First Three Formant Frequencies (F1, F2, F3)
% formant_freqs = angle(poles) * (fs / (2 * pi));  % Convert to frequencies
% F1 = abs(formant_freqs(1));  % First formant
% F2 = abs(formant_freqs(2));  % Second formant
% F3 = abs(formant_freqs(3));  % Third formant
% fprintf('Formant frequencies: F1=%.2f Hz, F2=%.2f Hz, F3=%.2f Hz\n', F1, F2, F3);