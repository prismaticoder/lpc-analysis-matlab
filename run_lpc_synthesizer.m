synthesizer = LpcSpeechSynthesizer('heed_f.wav', 25, 'lpc');

synthesizer.plotFrequencyResponses();

synthesizer.estimateFormantFrequencies();

synthesizer.getMeanFundamentalFrequency();

synthesizer.synthesize('heed_f_output.wav');