load('final2017_p1.mat');
%Code for part a)
y = speech;
figure
plot(y)
ham = hamming(250);
%Make window
windowed_y = y(1:250)'.*ham;
figure
plot(windowed_y)
%Take fft
ffy = fft(windowed_y,1024);
%Find magnitude of fft
for i = 1:length(ffy)
    magffy(i) = abs(ffy(i));
end
%Find fourier of real cepstrum
for i = 1:length(ffy)
    logffy(i) = log(abs(ffy(i))^2);
end
%Get the real cepstrum
ilogffy = ifft(logffy);
%ilogffy(1) = 0;
%ilogffy(end) = 0;
ilogffy;
figure
plot(ilogffy(1:200))
% inds = 0;
% for i = 20:140
%     if abs(ilogffy(i)) > 10*abs(ilogffy(i+1))
%         inds = [inds, i];
%     end
% end
% inds



%Part b)
%Find the max of the cepstrum between 20 and 140. This is the peak
[mag, ind] = max(abs(ilogffy(20:140)))
%Correct for the index (starts at 20, not 0)
trueind = ind+20
%Find pitch by dividing by sampling rate
pitch = (10000/trueind)



%Part c)
%Find the quantization levels
quantized_pitch = 50:250/(-1+2^7):300;
%Find the closest level to the pitch we found
tmp_quant = abs(quantized_pitch - pitch);
[err, ind_quant] = min(tmp_quant)
quant_val = quantized_pitch(ind_quant)
percent_err = abs(quant_val-pitch)/pitch



%Part d)
max_c_quant = max(ilogffy(1:28));
min_c_quant = min(ilogffy(1:28));
quantized_c = min_c_quant:(max_c_quant-min_c_quant)/(-1+2^7):max_c_quant;
%Use this function
x = 1:28;
myfun = 6./x;

for i = 1:28
    temp_quant = -myfun(i):(2*myfun(i)/(-1+2^7)):myfun(i);
    temp_abs = abs(temp_quant - ilogffy(i));
    [err, ind_temp_quant] = min(temp_abs);
    cq(i) = temp_quant(ind_temp_quant);
end

%Results are GREAT
figure
plot(cq)
figure
plot(ilogffy(1:28))


%Part e)
%Lifter!
cq_res = cq;
for i = 2:length(cq)
    cq_res(i) = cq(i)*2;
end


%See what the lifter does to signal
%figure
%plot(cq_res)

%Take fft
refft = fft(cq_res,1024);

%This was for visualization
% for i = 1:length(refft)
%     R(i) = abs(refft(i));
%     ang(i) = angle(refft(i));
% end
% figure
% subplot(2,1,1)
% plot(R(1:500))
% subplot(2,1,2)
% plot(ang(1:500))

%Exponentiate
for i = 1:length(refft)
    exprefft(i) = exp(refft(i));
end
%Take the ifft's real part to get the minimum-phase reconstruction
new = real(ifft(exprefft));
%figure
%plot(new(1:200))
