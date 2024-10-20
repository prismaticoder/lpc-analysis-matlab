classdef LpcSpeechSynthesizer < handle
    properties
        Filename
        Order
        LpcMethod
        Fs % Sampling frequency
        SpeechSegment % The selected vowel segment
        SegmentLength % Length of the speech segment
        LpcCoeffs % LPC coefficients
        FormantFrequencies % Estimated formant frequencies
        MeanF0 % Mean fundamental frequency
    end

    methods
        function obj = LpcSpeechSynthesizer(filename, order, lpcMethod)
            % Check if the file exists
            if ~isfile(filename)
                error('The specified file does not exist: %s', filename);
            end

            % Check if the LPC method is valid
            validMethods = {'lpc', 'aryule', 'arcov'};
            if ~any(strcmp(lpcMethod, validMethods))
                error('Invalid LPC method: %s. Valid methods are: %s', lpcMethod, strjoin(validMethods, ', '));
            end

            % check if the order is a positive integer
            if ~isnumeric(order) || order <= 0 || mod(order, 1) ~= 0
                error('The order must be a positive integer.');
            end

            % If inputs are valid, proceed with initialisation
            obj.Filename = filename;
            obj.Order = order;
            obj.LpcMethod = lpcMethod;

            % Read audio file and store sampling frequency
            [speechSignal, samplingFreq] = audioread(filename);

            obj.Fs = samplingFreq;

            segmentDurationInMs = 100;
            segmentDurationSamples = round((segmentDurationInMs / 1000) * obj.Fs); % Convert to samples

            startSample = 50;

            obj.SpeechSegment = speechSignal(startSample:startSample + segmentDurationSamples - 1);
            obj.SegmentLength = length(obj.SpeechSegment);
        end

        % Method to plot frequency responses
        function plotFrequencyResponses(obj)
            % Calculate LPC coefficients
            obj.getLpcCoeffficients();

            freqz(1, obj.LpcCoeffs, 512, obj.Fs);

            % Get frequency response of LPC filter
            [h, f] = freqz(1, obj.LpcCoeffs);

            % Convert frequency to Hz
            f_lpc = f * obj.Fs / (2 * pi); % Convert to Hz

            % Calculate amplitude spectrum of speech segment
            X = fft(obj.SpeechSegment);
            X_mag = abs(X);
            X_dB = 20*log10(X_mag);
            frequency_axis = (0:length(X)-1) * obj.Fs / length(X);

            % Plot both frequency responses
            figure;
            plot(f_lpc, 20*log10(abs(h)), 'r', 'LineWidth', 2.5);

            hold on;
            plot(frequency_axis(1:obj.SegmentLength/2), X_dB(1:obj.SegmentLength/2), 'b');

            hold on;

            % Denote first 3 peaks in the speech segment
            % Find the peaks
            [peaks, locs] = findpeaks(20*log10(abs(h)), f_lpc, 'NPeaks', 3); % Find first 3 peaks

            % Plot the peaks with dots
            plot(locs, peaks, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'g'); % Green dots at peaks

            % Label the peaks
            text(locs(1), peaks(1), 'F1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
            text(locs(2), peaks(2), 'F2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
            text(locs(3), peaks(3), 'F3', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

            % Label the axes and add a legend
            xlabel('Frequency (Hz)');
            ylabel('Magnitude (dB)');
            title('LPC Filter and Speech Segment Frequency Responses');
            legend(sprintf('LPC Filter p = %d', obj.Order), 'Speech Segment');
            hold off;
        end

        % Method to plot pole-zero plot
        function plotPoleZeroPlot(obj)
            % Calculate LPC coefficients
            obj.getLpcCoeffficients();

            zplane(1, obj.LpcCoeffs);
            title('Pole-Zero Plot of LPC Filter');
        end

        % Method to calculate LPC coefficients
        function getLpcCoeffficients(obj)
            switch obj.LpcMethod
                case 'lpc'
                    obj.LpcCoeffs = lpc(obj.SpeechSegment, obj.Order);
                case 'aryule'
                    obj.LpcCoeffs = aryule(obj.SpeechSegment, obj.Order);
                case 'arcov'
                    obj.LpcCoeffs = arcov(obj.SpeechSegment, obj.Order);
                otherwise
                    error('Invalid LPC method specified.');
            end
        end

        % Method to estimate formant frequencies
        function estimateFormantFrequencies(obj)
            % Get LPC coefficients if not already calculated
            if isempty(obj.LpcCoeffs)
                obj.getLpcCoeffficients();
            end

            [h, f] = freqz(1, obj.LpcCoeffs);

            % Convert frequency to Hz
            f_lpc = f * obj.Fs / (2 * pi); % Convert to Hz

            [~, locs] = findpeaks(20*log10(abs(h)), f_lpc);  % Find peak
            formants = locs(1:3);  % First three peaks are the formants
            % ... (Your formant estimation logic here) ...
            obj.FormantFrequencies = formants;

            % Display the estimated formant frequencies
            fprintf('Estimated Formant Frequencies: F1 = %.2f Hz, F2 = %.2f Hz, F3 = %.2f Hz\n', formants(1), formants(2), formants(3));
        end

        % Method to synthesize speech
        function synthesize(obj, outputFilename)
            % Get LPC coefficients if not already calculated
            if isempty(obj.LpcCoeffs)
                obj.getLpcCoeffficients();
            end

            % Get mean fundamental frequency if not already calculated
            if isempty(obj.MeanF0)
                obj.getMeanFundamentalFrequency();
            end

            % Confirm output filename has .wav extension
            [~, ~, ext] = fileparts(outputFilename);
            if ~strcmp(ext, '.wav')
                error('Output filename must have .wav extension.');
            end

            % Generate impulse train
            durationInSeconds = 1;
            numberOfSamples = round(durationInSeconds * obj.Fs);

            impulse_train = zeros(1, numberOfSamples);
            impulse_spacing = round(obj.Fs / obj.MeanF0);
            impulse_train(1:impulse_spacing:end) = 1;

            % Filter impulse train using LPC filter
            synthesized_speech = filter(1, obj.LpcCoeffs, impulse_train);

            % Normalize audio data so it isn't clipped with audiowrite
            maxVal = max(abs(synthesized_speech));
            if maxVal > 1
                synthesized_speech = synthesized_speech / maxVal;  % Normalize to [-1, 1]
            end

            % Write synthesized speech to a WAV file
            audiowrite(outputFilename, synthesized_speech, obj.Fs);
        end

        % Method to calculate the mean fundamental frequency
        function getMeanFundamentalFrequency(obj)
            obj.MeanF0 = mean(pitch(obj.SpeechSegment, obj.Fs));

            % Display the mean fundamental frequency
            fprintf('Mean Fundamental Frequency (F0): %.2f Hz\n', obj.MeanF0);
        end
    end
end