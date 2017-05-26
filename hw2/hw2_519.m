f1 = 750; f2 = 1100; %/a/
% f1 = 300; f2 = 2300; %/e/

Fs = 16000;
timedur = 1;
t = 0:1/Fs:timedur;
pitch = 200; %in Hz
imptrain = upsample(ones(1,pitch),round(Fs/pitch)); %should be of length time * Fs now

alpha1 = (pi*0.005 - 0.01*f1*(1/Fs));
alpha2 = (pi* 0.005 -0.01*f2*(1/Fs));
signal1 = exp(-alpha1*t).*cos(2*pi*f1*t);
signal2 = exp(-alpha2*t).*cos(2*pi*f2*t);
signal = conv(signal1,signal2);
finalsignal = conv(signal,imptrain);
finalsignal = finalsignal(1:Fs*timedur);