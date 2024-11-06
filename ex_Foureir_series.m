clear all
close all
grid on

dt = 0.001;
t = -4:dt:12-dt;
sig1 = sin(2*pi/4*t);
sig2 = (sig1 <= 0);
figure(1)
plot(t, sig1, t, sig2)

K = -20:20;
T0 = 4;
F0 = 1/T0;
t1 = -4:dt:-dt;
sig2_p1 = sig2(1:length(t1));
figure(24)
plot(t, sig2, t1, sig2_p1)

for k = 1:length(K)
  
  cc(k) = (1/T0)*sum(sig2_p1.*exp(-j*2*pi*K(k)*(1/T0)*t1))*dt;
  
end

for r = 1:length(t)
  XR1(r) = sum(cc.*exp(j*2*pi*K*F0*t(r)));
endfor
figure(2)
plot(t, real(XR1), t, sig2)

XR2 = zeros(size(t));
for r = 1:length(K)
  XR2 = XR2 + cc(r).*exp(j*2*pi*K(r)*F0*t);
endfor
figure(3)
plot(t, real(XR2), t, sig2)

XR3 = zeros(size(t));
k_idx = find(K == 1 | K == -1 | K == 0);
for r = 1:length(k_idx)
  XR3 = XR3 + cc(k_idx(r)).*exp(j*2*pi*K(k_idx(r))*F0*t);
endfor
figure(4)
plot(t, real(XR3), t, real(XR1))

fp2 = abs(cc).^2;
Px = sum(fp2);
figure(5)
stem(K*F0, fp2)



