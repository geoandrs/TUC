clear all
close all

fs = 8000;%sampling frequency
ts = 1/fs;
N = 256;%number of samples
n = 0:N-1;%discrete time

k = 1;
for f0 = [100:125:475 7525:125:7900];

%create sampled signal
x = sin(2*pi*f0*ts*n+15);
f = [-fs/2:fs/N:fs/2 - fs/N];
figure(k)
k = k+1;
%Fourier Transform of the signal
stem(f,fftshift(abs(fft(x,N))))
title("Fourier range")
xlabel("f(Hz)")
ylabel("amplitude");

end