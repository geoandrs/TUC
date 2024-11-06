clear all;
close all;

a = input("give me a: ");

dt = 0.001;
t = -3:dt:3-dt;
fs = 1/dt;

x = a*sinc(a*t);
figure()
plot(t,x)

N = length(t);
f = -fs/2 : fs/N : fs/2 - fs/N;

for k = 1:length(f)
  
  XF(k) = sum(x.*exp(-j*2*pi*t*f(k)))*dt;
  
end

figure()
plot(f, abs(XF))
xlim([-20 20])
ylim([-0.25 1.5])

XF2_2 = fftshift(fft(x)*dt);
figure()
plot(f, abs(XF2_2))
xlim([-20 20])
ylim([-0.25 1.5])

NFFT = 2^nextpow2(length(x));
ff = -fs/2 : fs/NFFT : fs/2 - fs/NFFT;
XF2 = fftshift(fft(x, NFFT)*dt);
figure()
plot(ff, abs(XF2))
xlim([-20 20])
ylim([-0.25 1.5])
% XF2 XF2_2 idia

XF3 = (f > -a/2) - (f > a/2);
figure()
plot(f, XF3)
xlim([-20 20])
ylim([-0.25 1.5])