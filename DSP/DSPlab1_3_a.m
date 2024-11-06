clear all
close all

dt = 0.01;
t = [0:dt:1.5];

%create the continuous signal x
x = 10*cos(2*pi*20*t) - 4*sin(2*pi*40*t+5);
figure(1)
plot(t,x);
title("Sampling with 128 samples")
xlabel("time")
ylabel("amplitude");

%Sampling with Fs = 100Hz for 128 samples
Ts = 1/100;
N = 128;
td = [t(1):Ts:(N-1)*Ts];
xd = 10*cos(2*pi*20*td) - 4*sin(2*pi*40*td+5);
hold on
plot(td,xd,"r*")
hold off

%Fourier Transform of sampled signal
fs = 1/Ts;
f = [-fs/2:fs/N:fs/2-fs/N];
xf = fftshift(abs(fft(xd)));
figure(2)
stem(f,xf);
title("Fourier range")
xlabel("f(Hz)")
ylabel("amplitude");