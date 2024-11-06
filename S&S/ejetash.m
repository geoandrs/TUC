clear allclose all

ts = 0.001;t = -10:ts:10;
fs = 1/ts;
%a erwthma
x = zeros(1,length(t));
x(t >= -8 & t < -1.3) = exp(t(t >= -8 & t < -1.3)).*t(t >= -8 & t < -1.3).^(-2).*cos(8*pi*t(t >= -8 & t < -1.3));
x(t >= -1.3 & t <= 1.3) = 0.25*(1.32-abs(t(t >= -1.3 & t <= 1.3))).*exp(abs(t(t >= -1.3 & t <= 1.3)));
x(t > 1.3 & t <= 8) = (1/30)*sin(210*pi*t(t > 1.3 & t <= 8)).*exp(abs(t(t > 1.3 & t <= 8)/3));
plot(t,x)

%b erwthma
NFFT = 2^nextpow2(length(x));
ff = -fs/2 : fs/NFFT : fs/2 - fs/NFFT;
XF = fftshift(fft(x, NFFT)*ts);
figure()
plot(ff, abs(XF))
xlim([-300 300])

%c erwthma
t2 = -2.5:ts:2.5;
a = 120;
y = a*sinc(a*t2);
figure()
plot(t2,y)

Ny = length(t2);
fy = -fs/2 : fs/Ny : fs/2 - fs/Ny;
YF = fftshift(fft(y)*ts);
figure()
plot(fy, abs(YF))
xlim([-300 300])

%d erwthma
tz = t(1)+t2(1):ts:t(end)+t2(end);
z = conv(x, y)*ts;
figure()
plot(tz, z)

Nz = length(tz);
fz = -fs/2 : fs/Nz : fs/2 - fs/Nz;
ZF = fftshift(fft(z)*ts);
figure()
plot(fz, abs(ZF))
xlim([-30 30])