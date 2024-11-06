clear all
close all

dt = 0.001;
t = -6:dt:6-dt;

T0 = 4;
F0 = 1/T0;

sig1 = sin(2*pi*F0*t);
sig2 = (sig1 <= 0) - 0.5;
sig3 = (sig1 <= 0) - 1;
figure(1)
plot(t, sig1, t, sig2)
figure(2)
plot(t, sig1, t, sig3)

t1 = -6:dt:-2-dt;
sig2_p1 = sig2(1:length(t1));
sig3_p1 = sig3(1:length(t1));

K = [-20:20];
for k = 1:length(K)
  
  cc2(k) = F0*sum(sig2_p1.*exp(-j*2*pi*K(k)*F0*t1))*dt;
  cc3(k) = F0*sum(sig3_p1.*exp(-j*2*pi*K(k)*F0*t1))*dt;
    
endfor

fp2 = abs(cc2).^2;
Px2 = sum(fp2);
figure(3)
stem(K*F0, fp2)
fp3 = abs(cc3).^2;
Px3 = sum(fp3);
figure(4)
stem(K*F0, fp3)

for k = 1:length(t)
  
  XR2(k) = sum(cc2.*exp(j*2*pi*K*F0*t(k)));
  XR3(k) = sum(cc3.*exp(j*2*pi*K*F0*t(k)));
  
endfor

figure(5)
plot(t, sig2, t, real(XR2))
figure(6)
plot(t, sig3, t, real(XR3))





