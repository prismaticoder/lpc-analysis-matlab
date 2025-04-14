# LPC Speech Synthesizer

A MATLAB-based speech analysis and synthesis tool using Linear Predictive Coding (LPC) techniques. This tool allows users to analyze vowel speech signals, extract key acoustic features like formants and fundamental frequency, and synthesize speech based on these parameters.

## Features
- Load and analyze WAV audio files
- Extract speech segments for analysis
- Calculate LPC coefficients using different methods (lpc, aryule, arcov)
- Estimate formant frequencies (F1, F2, F3)
- Determine fundamental frequency (F0) with speaker type consideration
- Visualize frequency responses and compare with original speech spectrum
- Generate pole-zero plots of LPC filters
- Synthesize speech using LPC coefficients and calculated F0

## Requirements
- MATLAB (developed and tested with R2020b or newer)
- Signal Processing Toolbox

## Installation
1. Clone this repository or download the source files
2. Add the project folder to your MATLAB path

## Usage
### Basic Example

```matlab
% Create an LPC speech synthesizer instance
synthesizer = LpcSpeechSynthesizer('speech_sample.wav', 12, 'lpc', 'male');

% Analyze and display information
synthesizer.getLpcCoeffficients();
synthesizer.estimateFormantFrequencies();
synthesizer.getMeanFundamentalFrequency();

% Visualize results
synthesizer.plotFrequencyResponses();
synthesizer.plotPoleZeroPlot();

% Synthesize speech
synthesizer.synthesize('output_speech.wav');
```

### Parameter Explanation
- `filename`: Path to a .wav audio file
- `order`: LPC model order (typical values: 10-16 for speech)
- `lpcMethod`: Method for LPC calculation ('lpc', 'aryule', or 'arcov')
- `speakerType`: Type of speaker ('male', 'female', or 'any')

### Understanding the Code
#### Linear Predictive Coding (LPC)
LPC is a method used in audio signal processing for representing the spectral envelope of a digital signal. It is particularly useful for speech analysis and synthesis because it models the vocal tract as an all-pole filter.

#### Formant Frequencies
Formants are the resonant frequencies of the vocal tract. They are crucial in determining the quality of vowels in speech. The first three formants (F1, F2, F3) are especially important for vowel identification.

#### Fundamental Frequency (F0)
F0 represents the pitch of the voice. It varies depending on the speaker (typically 85-180 Hz for males and 165-255 Hz for females).

### Methods
- `getLpcCoeffficients()`: Calculates LPC coefficients using the selected method
- `estimateFormantFrequencies()`: Estimates the first three formant frequencies
- `getMeanFundamentalFrequency()`: Calculates the mean fundamental frequency
- `plotFrequencyResponses()`: Plots both the LPC filter and speech segment frequency responses
- `plotPoleZeroPlot()`: Displays the pole-zero plot of the LPC filter
- `synthesize()`: Generates synthesized speech based on the LPC model

## Acknowledgements
This project is designed for educational purposes to demonstrate speech signal processing techniques.

