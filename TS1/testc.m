clear all
close all 

T = 0.1;
over = 10;
a = 0.5;
A = 5;
Ts = T/over;
Fs = 1/Ts;
N = 50; %100
i = 0:N-1;

b = (sign(randn(N,1))+1)/2;
X = bits_to_2PAM(b);

X_delta = Fs*upsample(X,over);
td = linspace(0,N*T,N*over);
figure();
plot(td,X_delta);
grid on;
title("Xdelta signal");
xlabel("Time (sec)");
ylabel("Xdelta");

%if we try to sample the SRRC pulse with sampling
%frequency 1/Ts then we have the same signal as 
%the return value of the function
[phi,t] = srrc_pulse(T, over, A, a);
figure();
plot(t,phi);
grid on;
title("SRRC pulse");
xlabel("Time (sec)");
ylabel("SRRC pulse");

Xt = conv(phi,X_delta)*Ts;
tt = linspace(td(1)+t(1),td(end)+t(end),length(Xt));
figure();
plot(tt,Xt);
grid on;
title("Convolution for 2-PAM (transmitter)");
xlabel("Time (sec)");
ylabel("X(t)");

% in theory we want phi(-t) but practically
% phi(-t) = phi(t)
% these 2 lines is to produce the inverted signal
% but we don't need them
% rev_phi = fliplr(phi);
% t_rev = -fliplr(t);

Z = conv(Xt,phi)*Ts;
tz = linspace(tt(1)+t(1),tt(end)+t(end),length(Z));
figure();
plot(tz,Z);
hold on 
stem([0:N-1]*T,X,"r");
grid on;
title("Convolution for 2-PAM (receiver)");
xlabel("Time (sec)");
ylabel("Z(t), Xk");
legend("Z(t)", "Xk");
hold off
