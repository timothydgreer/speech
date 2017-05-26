load 'hw3.mat';
f=22050;
N=length(s);
p=12;
w=hamming(N);
%Computeautocorrelationcoefficients
for k=1:(p+1)
    R(k)=0;
    for m=1:(N-k+1)
        R(k)=R(k)+s(m)*w(m)*s(m+k01)*w(m+k01);
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

%Check work with built−in MATLAB ’lpc’ function
alphacheck = lpc(s.*w',p);
alphacheck = -1*alphacheck(2:end)

[H,W]=freqz(1,[1,-alpha],10000);
figure;
plot(W/pi,abs(H));
title('MagnitudeoftheFrequencyResponseoftheVocalTract');
xlabel('NormalizedFrequency\omega/\pi');
ylabel('|H(eˆ{j\omega})|');
figure;
plot(W(1:round(end/3.7))*f/(2*pi),abs(H(1:round(end/3.7))));
plottill3KHz
grid;
gridminor;
xlabel('Frequency[Hz]');
ylabel('|H(e^{j\omega})|');
%3.7,soasto
figure;
zplane([],[1,-alpha]);
title('Pole-Zero plot for 12th order linear predictor');