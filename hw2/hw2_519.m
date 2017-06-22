%f1 = 750; f2 = 1100; %/a/
f1 = 300; f2 = 2300; %/e/

Fs = 16000;
timedur = 1;
t = 0:1/Fs:timedur;
pitch = 200; %in Hz

%This is the exciter
imptrain = upsample(ones(1,pitch),round(Fs/pitch)); %should be of length time * Fs now


alpha1 = (pi*0.005 - 0.01*f1*(1/Fs));
alpha2 = (pi*0.005 - 0.01*f2*(1/Fs));
signal1 = exp(-alpha1*t).*cos(2*pi*f1*t);
signal2 = exp(-alpha2*t).*cos(2*pi*f2*t);
signal = conv(signal1,signal2);
finalsignal = conv(signal,imptrain);
finalsignal = finalsignal(1:Fs*timedur);

sound(finalsignal, Fs)
% They do not resemble typical pronunciations, although distinctions can be
% made between them. This can be due to vocal tract excitation approximated
% with an impulse (or) only first two formants information used (or) 
%constant energy throughout the entire duration.
% Further, the decay constant alpha i controls the damping of sinusoids. 
%Increasing alpha i will help make the vowels sound better.
