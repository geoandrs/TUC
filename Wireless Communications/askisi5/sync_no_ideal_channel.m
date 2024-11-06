clear 
close all


over = 10; % oversampling factor
T = 0.1; % symbol period
Ts = T/over; % sampling period
Fs = 1/Ts; % sampling frequency
N = 200; % symbols 
Ntr = 40; % training symbols
b = 0.4; % roll-off factor
B = 3; % half duration of the pulse in symbol periods
DFs = 0.001; % for help to set the value for CFO
DF = DFs/Ts; % CFO
K = 2*over; % K ~ U{1,...,4*over}
M = 5; % channel length
L = 5*M; % ZF Equalizer length
Delta = M; % ZF Equalizer delay


An = sign(randn(N,1))+1i*sign(randn(N,1)); % 4-QAM symbol sequence
train = An(1:Ntr); % training symbols

[phi,t] = srrc_pulse(T, over, B, b); % srrc pulse 

A = Fs*upsample(An,over); % upsample to have 1 symbol every over
td = linspace(0,N*T,N*over); % time for the input symbols

At = conv(A,phi)*Ts; % output after the srrc filter at transmitter

finish = td(end)+t(end);
tt = linspace(0,finish,length(At)); % time at transmitter

% figure() % plot real and imaginary of the signal at transmitter
% subplot(211)
% plot(tt,real(At))
% subplot(212)
% plot(tt,imag(At))

% the impulse response of our channel is c(t) = c1*δ(t)+c2*δ(t-KTs)
% conv(At,c(t)) = conv(At,c1*δ(t)) + conv(At,c2*δ(t-KTs)) = c1*At + c2*At(t-KTs)

c = randn(2,1) + 1i*randn(2,1); % 2 complex numbers to multiply channel

At_tmp = zeros(length(At)+K,1);
At_tmp(K+1:end) = At;

Ar1 = [c(1)*At ; zeros(K,1)];
Ar2 = c(2)*At_tmp;

Ar_in = Ar1 + Ar2;

Ar = conv(Ar_in,phi)*Ts;

h_tmp = zeros(1,length(phi)+K);
h_tmp(K+1:end) = phi;

h1 = [c(1)*phi zeros(1,K)];
h2 = c(2)*h_tmp;

ch = h1 + h2;

channel = conv(ch,phi)*Ts;

figure()
plot(1:length(channel), abs(channel))
title("absolute value of composite channel")
xlabel("time")

len = 4*B*over+K;
corr = zeros(1,(4*B*over-1));
corr_abs = zeros(1,(4*B*over-1));
for d = 1:len

    Asample = Ar(d:over:Ntr*over+d-1);
    Asample_train = conj(train).*Asample;

    corr(d) = sum(Asample_train);
    corr_abs(d) = abs(corr(d));

end

figure()
stem(1:len, corr_abs)
title("corrd abs")
xlabel("d")

d = find(corr_abs == max(corr_abs));

A_corr_syn = Ar(d:over:N*over+d-1);

scatterplot(A_corr_syn)

len_Ed = len-M*over;
Ed = zeros(1,len_Ed);
for d = 1:len_Ed
    
    ed = 0;
    
    for m = 1:M
        sample = d + m - 1;
        ed = ed + (corr_abs(sample))^2;
    end
    
    Ed(d) = ed;
    
end
d_star = find(Ed == max(Ed));

tot = (N+M-1)*over+d_star-1;
A_Ed = Ar(d_star:over:tot);

scatterplot(A_Ed);

h = Estimate_Channel(An,1,Ntr,M-1,A_Ed.');

ZF = ZF_Equalizer(h,L,M-1,Delta);

A_ZF = conv(A_Ed,ZF);

A_est = A_ZF(Delta:N+Delta-1);

scatterplot(A_est);