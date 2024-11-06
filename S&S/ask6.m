clear all
close all

dt = 0.001;
N = 2;
T = 15;
f = 1/T;

t = -5:dt:10-dt;
x = abs(cos(0.2*pi*t));
x(t >= 0) = (2/3).^t(t >= 0);
tt = 6:dt:10-dt;
x(t >= 6) = ones(size(tt));

tol = [];
xol = [];

for k = 1:N
  
  tol = [tol (t+(k-1)*T)];
  xol = [xol x]; 
  
end
plot(tol, xol)

K = [-50:50];
for k = 1:length(K)
  
  cc(k) = f*sum(x.*exp(-j*2*pi*K(k)*f*t))*dt;
  
end

fp = abs(cc).^2;
figure(2)
stem(K*f, fp)

for k = 1:length(tol)
  
  XR(k) = sum(cc.*exp(j*2*pi*K*f*tol(k)));
  
end
figure(3)
plot(tol, xol, tol, real(XR))

cc_max = max(fp);
r = cc > 0.05*cc_max;
k_idx = find(r == 1);
XR2 = zeros(size(tol));
for r = 1:length(k_idx)
  XR2 = XR2 + cc(k_idx(r)).*exp(j*2*pi*K(k_idx(r))*f*tol);
endfor
figure(4)
plot(tol, real(XR2), tol, real(XR))



