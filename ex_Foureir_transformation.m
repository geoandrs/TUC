clear all
close all

dt = 0.01;
fs = 1/dt;
t = -25:dt:25;
N = length(t);
T = 10;
x = ((t >= -5) - (t >= 5));
figure(1)
plot(t,x)
axis([ -10 10 -0.2 1.2 ])

f = -fs/2 : fs/N : fs/2 - fs/N;

for k = 1:length(f)
  
  XF(k) = sum(x.*exp(-j*2*pi*t*f(k)))*dt;
  
end

figure(2)
plot(f, abs(XF))
axis([ -2 2 -1 11])

XF2 = T*sinc(f*T);
figure(3)
plot(f, abs(XF2))
axis([ -2 2 -1 11])

difference = max(abs(XF2-real(XF)))

NFFT = 2^nextpow2(length(x));
ff = -fs/2 : fs/NFFT : fs/2 - fs/NFFT;
XF3 = fftshift(fft(x, NFFT)*dt);
figure(4)
plot(ff, abs(XF3))
axis([ -2 2 -1 11])

figure(5)
subplot(3,1,1)
semilogy(f, abs(XF))
xlim([-2 2])
subplot(3,1,2)
semilogy(f, abs(XF2))
xlim([-2 2])
subplot(3,1,3)
semilogy(ff, abs(XF3))
xlim([-2 2])


