[y,Fs] = audioread('hw1_q8.wav');
Fs
%spectrogram(y,blackman(80),20)
%hold off
%figure
%spectrogram(y,blackman(800),600)
plot(y)

[y,Fs] = audioread('500.wav');
spectrogram(y,blackman(80),20)
hold off
figure

[y,Fs] = audioread('4000.wav');
spectrogram(y,blackman(80),20)
hold off