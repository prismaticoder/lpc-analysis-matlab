% Female Speech Synthesizer
synthesizer = LpcSpeechSynthesizer('heed_f.wav', 25, 'lpc', 'female');

synthesizer.plotFrequencyResponses();

synthesizer.estimateFormantFrequencies();

synthesizer.getMeanFundamentalFrequency();

synthesizer.plotPoleZeroPlot();

synthesizer.synthesize('heed_f_synthesized.wav');

% Male Speech Synthesizer
synthesizer = LpcSpeechSynthesizer('heed_m.wav', 25, 'lpc', 'male');

synthesizer.plotFrequencyResponses();

synthesizer.estimateFormantFrequencies();

synthesizer.getMeanFundamentalFrequency();

synthesizer.plotPoleZeroPlot();

synthesizer.synthesize('heed_m_synthesized.wav');