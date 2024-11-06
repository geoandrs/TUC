clear all
close all

dt = 0.01;

t1 = [-4:dt:6];
x1 = (abs(t1/6).^abs(t1)).*exp(-abs(t1/4)).*cos(2*pi*t1);
subplot(3,3,1)
plot(t1, x1)

t2 = -t1(end:-1:1)-2;
x2 = x1(end:-1:1);
subplot(3,3,2)
stem(t2, x2)

ty = [t1(1) + t2(1):dt:t1(end) + t2(end)];
Y = conv(x1, x2)*dt;
subplot(3,3,4:6)
stem(ty, Y)

t3 = [-3:dt:3];
x3 = sin(pi*t3)./(pi*t3);
x3(t3 == 0) = 1;
subplot(3,3,3)
plot(t3, x3)

ty2 = [t3(1) + ty(1):dt:t3(end) + ty(end)];
Y2 = conv(x3, Y)*dt;
subplot(3,3,7:9)
stem(ty2, Y2)
