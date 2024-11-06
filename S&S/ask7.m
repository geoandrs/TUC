clear all;
close all;

dt = 0.001;
t = -5:dt:5;
fs = 1/dt;
N = length(t);

x = (1 - abs(t)).*((t >= -1) - (t >= 1));
figure(1)
plot(t,x)
ylim([-0.5 1.5])

f = -fs/2 : fs/N : fs/2 - fs/N;

for k = 1:length(f)
  
  XF(k) = sum(x.*exp(-j*2*pi*t*f(k)))*dt;
  
end

figure(2)
plot(f, abs(XF))
xlim([-20 20])

XF2_2 = fftshift(fft(x)*dt);
figure(24)
plot(f, abs(XF2_2))
xlim([-20 20])

NFFT = 2^nextpow2(length(x));
ff = -fs/2 : fs/NFFT : fs/2 - fs/NFFT;
XF2 = fftshift(fft(x, NFFT)*dt);
figure(3)
plot(ff, abs(XF2))
xlim([-20 20])
% XF2 XF2_2 idia

XF3 = sinc(f).^2;
figure(4)
plot(f, XF3)
xlim([-20 20])