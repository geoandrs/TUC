clear all;
close all;

ts = 0.001;
fs = 1/ts;
t = -2.5:ts:3.5-ts;

x = cos(120*pi*t).*(1-abs(t)/2) + cos(240*pi*t);
x(t >= -2.5 & t < -1.2) = 3.^(-abs(t(t >= -2.5 & t < -1.2)/2)).*sin(600*pi*t(t >= -2.5 & t < -1.2)) + abs(cos(300*pi*t(t >= -2.5 & t < -1.2)));
x(t > 1.2) = 3.^(-abs(t(t > 1.2)/2)).*cos(400*pi*t(t > 1.2)) + abs(sin(200*pi*t(t > 1.2)));

plot(t,x)

N1 = length(t);
f1 = -fs/2 : fs/N1 : fs/2 - fs/N1;
XF1 = fftshift(fft(x)*ts);
figure()
plot(f1, abs(XF1))

N2 = 2048;
f2 = -fs/2 : fs/N2 : fs/2 - fs/N2;
XF2 = fftshift(fft(x,N2)*ts);
figure()
plot(f2, abs(XF2))

N3 = 2^13;
f3 = -fs/2 : fs/N3 : fs/2 - fs/N3;
XF3 = fftshift(fft(x,N3)*ts);
figure()
plot(f3, abs(XF3))

t2 = -1.3:ts:1.3;
a = 300;
y = a*sinc(a*t2); % xamhloperato filtro
figure()
plot(t2, y)

Ny = length(t2);
fy = -fs/2 : fs/Ny : fs/2 - fs/Ny;
YF = fftshift(fft(y)*ts);
figure()
plot(fy, abs(YF))

tz = t(1)+t2(1):ts:t(end)+t2(end);
z = conv(x, y)*ts; %gia sunexous xronou *dt
figure()
plot(tz, z)

Nz = length(tz);
fz = -fs/2 : fs/Nz : fs/2 - fs/Nz;
ZF = fftshift(fft(z)*ts);
figure()
plot(fz, abs(ZF))

tp = -14.5:ts:15.5-ts;
periods = length(tp)/length(t);
xp = [];

for k = 1:periods
  
  xp = [xp x]; 
  
end
figure()
plot(tp, xp)

K = -100:100;
T0 = t(end) - t(1);
F0 = 1/T0;
for k = 1:length(K)
  
  cc(k) = F0*sum(x.*exp(-j*2*pi*K(k)*F0*t))*ts;
  
end

fp = abs(cc).^2;
figure()
stem(K*F0, fp)

XPR = zeros(size(tp));
k_idx = find(abs(K) <= 4); % K >= -4 & K <= 4 alliws
for r = 1:length(k_idx)
  XPR = XPR + cc(k_idx(r)).*exp(j*2*pi*K(k_idx(r))*F0*tp);
end
figure()
plot(tp, real(XPR))
