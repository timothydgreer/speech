load 'hw3.mat';
f=22050;
N=length(s);
p=12;
w=hamming(N);
%Compute autocorrelation coefficients
for k=1:(p+1)
    R(k)=0;
    for m=1:(N-k+1)
        R(k)=R(k)+s(m)*w(m)*s(m+k-1)*w(m+k-1);
    end
end
%Implement Durbin’s recursive solution
E(1)=R(1);%Initialize prediction error
alpha(1)=R(2)/R(1);%Solve for first LPC

for i=2:p
    kappa=alpha;
    E(i)=(1-(alpha(i-1))^2)*E(i-1);
    Rsum(i)=0;
    for j=1:(i-1)
        Rsum(i)=Rsum(i)+alpha(j)*R(i-j+1);
    end

    alpha(i)=(R(i+1)-Rsum(i))/E(i);

    for j=1:(i-1)
        alpha(j)=kappa(j)-alpha(i)*kappa(i-j);
    end
end

%Check work with built−in MATLAB 'lpc' function
alphacheck = lpc(s.*w,p);
alphacheck = -1*alphacheck(2:end)

%compare with our lpc
alpha

[H,W]=freqz(1,[1,-alpha],10000);
figure;
plot(W/pi,abs(H));
title('Magnitude of the Frequency Response of the Vocal Tract');
xlabel('Normalized Frequency\omega/\pi');
ylabel('|H(eˆ{j\omega})|');
figure;
plot(W(1:round(end/3.7))*f/(2*pi),abs(H(1:round(end/3.7))));
%3.7,so as to plot till 3 KHz
grid;
grid minor;
xlabel('Frequency[Hz]');
ylabel('|H(e^{j\omega})|');

figure;
zplane([],[1,-alpha]);
title('Pole-Zero plot for 12th order linear predictor');
%Formant frequencies (neglecting formants above 4 KHz)

