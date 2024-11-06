clear all
close all

%create signal 1
n1 = [0:10];
signal1 = exp(-n1);

%create signal 2
n2 = [0:20];
signal2 = n2;

nconv = [n1(1) + n2(1):n1(end) + n2(end)];%convolution time
%create convolution
C = conv(signal1, signal2);
subplot(2,2,1:2)
stem(nconv, C)
title("Convolution");
xlabel("time");
ylabel("amplitude");

%create Fourier Transform for signal1 and signal2 
fsignal1 = fft(signal1,length(nconv));
fsignal2 = fft(signal2,length(nconv));
%Inverted Fourier Transform
%to compare the 2 graphs in time division
fc = ifft(fsignal1.*fsignal2);
subplot(2,2,3:4)
stem(nconv, fc)
title("Convolution from Fourier multiplication");
xlabel("time");
ylabel("amplitude");


