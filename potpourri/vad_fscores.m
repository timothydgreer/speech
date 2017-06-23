[mywav,Fs]=audioread('vad.wav');
groundTruth=load('vad.csv');
vad=groundTruth(:,2)';
%Fraction of voiced frames:
disp(sum(vad)/length(vad) )%0.5183
%Framerate (in Hz)
disp(1/(groundTruth(2,1)-groundTruth(1,1))) %100Hz

%==========================================================================
%Part a)

manualannot=rand(1,length(vad))>0.5;
prec=sum(manualannot.*vad)/sum(manualannot);
rec=sum(manualannot.*vad)/sum(vad);
fmeas=2*prec*rec/(prec+rec);

%==========================================================================
%Part b)
buf=buffer(mywav,Fs/100);buf(:,end)=[];
ste=zeros(1,size(buf,2));
epsilon=power(10,-5);
L=size(buf,1);
for framenum=1:length(ste)
    ste(framenum)=10*log10(epsilon+(sum(power(buf(:,framenum),2)))/L);
end


allthresh=linspace(min(ste),max(ste),20);
allprec=zeros(1,length(allthresh));
allrec=zeros(1,length(allthresh));
allfmeas=zeros(1,length(allthresh));

for thresh=1:length(allthresh)
    stevad=zeros(1,length(vad));
    stevad(ste>allthresh(thresh))=1;
    if sum(stevad)~=0
        allprec(thresh)=sum(stevad.*vad)/sum(stevad);
    end
    allrec(thresh)=sum(stevad.*vad)/sum(vad);
    allfmeas(thresh)=2*allprec(thresh)*allrec(thresh)/(allprec(thresh)+allrec(thresh));
end

%==========================================================================
%Part c)
stzcr=zeros(1,size(buf,2));
for framenum=1:length(stzcr)
    stzcr(framenum)=mean(0.5*abs(diff(sign(buf(:,framenum)))));
end
allthresh=linspace(min(stzcr),max(stzcr),20); %mean(ste);
allprec=zeros(1,length(allthresh));
allrec=zeros(1,length(allthresh));
allfmeas=zeros(1,length(allthresh));

for thresh=1:length(allthresh)
    stzcrvad=zeros(1,length(vad));
    stzcrvad(stzcr<allthresh(thresh))=1;
    %Voiced frames are expected to have lower ZCR
    if sum(stzcrvad)~=0
        allprec(thresh)=sum(stzcrvad.*vad)/sum(stzcrvad);
    end
    allrec(thresh)=sum(stzcrvad.*vad)/sum(vad);
    allfmeas(thresh)=2*allprec(thresh)*allrec(thresh)/(allprec(thresh)+allrec(thresh));
end
