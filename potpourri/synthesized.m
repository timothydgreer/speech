%Reading in the data

formants=load('sa1.frm');
formant1=formants(:,1);
formant2=formants(:,2);
formant3=formants(:,3);
formant4=formants(:,4);

powers=load('sa1.pwr');
powers=power(10,powers/10);

pitchfreqs=load('sa1.f0');
%=======================================================================

%=======================================================================
%Glottal pulse of length 10ms
Fs=16000;

T=ceil(Fs/1000);
glottalpulse=zeros(1,T);
t2=ceil(0.4*T);

%Any other reasonable vocal tract functions will also work
for ii=1:1:t2
    glottalpulse(ii)=power(sin(pi/2*(ii/t2)),2);
end

for ii=t2+1:1:T
    glottalpulse(ii)=cos(pi/2*(ii-t2)/(T-t2));
end
%plot(glottalpulse);
lenglottalpulse=length(glottalpulse);
%=======================================================================

%=======================================================================
%Creating the impulse train
%Generate a 10ms − block of the signal every time. An impulse is placed at
%the appropriate location using the pitch information read from sa1.f0

mywindow=zeros(1,0.010*Fs);
residualsamples=0;
impulsetrain=[];
for ii = 1:1:length(pitchfreqs)
    pitchperiod = ceil(Fs/pitchfreqs(ii));
    tempwindow = mywindow;
    if (pitchfreqs(ii)==0)
        %Unvoiced region
        tempwindow=0.0005*randn(1,length(tempwindow));
        impulsetrain=[impulsetrain tempwindow];
        rng shuffle;
        continue;
    end

    if(residualsamples ~= 0)
        tempwindow(residualsamples:residualsamples+lenglottalpulse-1)...
        =sqrt(powers(ii))*glottalpulse;
    else
    tempwindow(1:lenglottalpulse)=sqrt(powers(ii))*glottalpulse;
    end
    [~, startloc] = max(tempwindow);
    index=pitchperiod;

    %Writetheimpulsestakingintoaccounttheresidual.
    while(startloc+index+lenglottalpulse<=0.010*Fs)
        tempwindow(startloc+index:startloc+index+...
        lenglottalpulse-1)=sqrt(powers(ii))*glottalpulse;
        index=index+pitchperiod;
    end
    residualsamples=(startloc+index+lenglottalpulse-0.010*Fs);
    impulsetrain=[impulsetrain tempwindow];
end
%=======================================================================

%=======================================================================
%Convolving with the vocal tract.
t=0:1/Fs:0.05;
%soundsc(impulsetrain);
synthesizedsignal=zeros(1,4*Fs);
for ii=1:1:(length(pitchfreqs)-1)
    f0 = formant1(ii)
    f1 = formant2(ii)
    f2 = formant3(ii)
    f3 = formant4(ii)
    alpha1 = (pi*0.005 - .01*f0*(1/Fs));
    alpha2 = (pi*0.005 - .01*f1*(1/Fs));
    alpha3 = (pi*0.005 - .01*f2*(1/Fs));
    alpha4 = (pi*0.005 - .01*f3*(1/Fs));

    signal1 = exp(-alpha1*t).*cos(2*pi*f0*t);
    signal2 = exp(-alpha1*t).*cos(2*pi*f1*t);
    signal3 = exp(-alpha1*t).*cos(2*pi*f2*t);
    signal4 = exp(-alpha1*t).*cos(2*pi*f3*t);

    signalaa=conv(signal1,signal2);
    signalbb=conv(signal3,signal4);
    signal=conv(signalaa,signalbb);

    tempwindow=impulsetrain((ii-1)*0.010*Fs+1:ii*0.010*Fs);

    tempoutputvowel=conv(signal,tempwindow);
    tempvowellength=length(tempoutputvowel);
    synthesizedsignal((ii-1)*0.010*Fs+1:(ii-1)*0.010*Fs+tempvowellength)...
    =synthesizedsignal((ii-1)*0.010*Fs+1:(ii-1)*0.010*Fs+tempvowellength)...
    +tempoutputvowel;
end
synthesizedsignal(50000:end)=[];%Remove trailing silence
%=======================================================================

%Scaleto−1:+1
y=2*((synthesizedsignal-min(synthesizedsignal))./...
(max(synthesizedsignal)-min(synthesizedsignal))-0.5);
sound(y,Fs);