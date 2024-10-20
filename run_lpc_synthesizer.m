% Female Speech Synthesizer
synthesizer = LpcSpeechSynthesizer('heed_f.wav', 25, 'lpc');

synthesizer.plotFrequencyResponses();

synthesizer.estimateFormantFrequencies();

synthesizer.getMeanFundamentalFrequency();

synthesizer.plotPoleZeroPlot();

synthesizer.synthesize('heed_f_output.wav');

% Male Speech Synthesizer
synthesizer = LpcSpeechSynthesizer('heed_m.wav', 25, 'lpc');

synthesizer.plotFrequencyResponses();

synthesizer.estimateFormantFrequencies();

synthesizer.getMeanFundamentalFrequency();

synthesizer.plotPoleZeroPlot();

synthesizer.synthesize('heed_m_output.wav');