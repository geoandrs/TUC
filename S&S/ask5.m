clear all
close all

d1 = input("dwse d1: ");
d2 = input("dwse d2: ");

dt = 0.001;

f0 = 1 + abs(d1-d2);
T0 = 1/f0;
f = 2*f0;
T = 1/f;

t = 0:dt:2*T;

x = abs(cos(2*pi*f0*t));
figure(1)
plot(t, x)

t1 = 0:dt:T;
x_p1 = x(1:length(t1));

K = [-20:20];
for k = 1:length(K)
  
  cc(k) = f*sum(x_p1.*exp(-j*2*pi*K(k)*f*t1))*dt;
  
end

fp = abs(cc).^2;
figure(2)
stem(K*f, fp)

for k = 1:length(t)
  
  XR(k) = sum(cc.*exp(j*2*pi*K*f*t(k)));
  
end
figure(3)
plot(t, x, t, real(XR))