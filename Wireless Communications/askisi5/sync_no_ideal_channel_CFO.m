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
DFs = 10^-3; % for help to set the value for CFO
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

% the impulse response of our channel is c(t) = c1*δ(t)+c2*δ(t-KTs)
% conv(At,c(t)) = conv(At,c1*δ(t)) + conv(At,c2*δ(t-KTs)) = c1*At + c2*At(t-KTs)

c = randn(2,1) + 1i*randn(2,1); % 2 complex numbers to multiply channel

At_tmp = zeros(length(At)+K,1);
At_tmp(K+1:end) = At;

Ar1 = [c(1)*At ; zeros(K,1)];
Ar2 = c(2)*At_tmp;

At_new = Ar1 + Ar2;

n = 1:length(At_new); % vector with length At_new
e = exp(1i*(2*pi*DFs).*n); % effect of CFO
Ar_in = At_new.*(e.'); % signal at the entrance of receiver

Ar = conv(Ar_in,phi)*Ts;

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
stem(1:len,corr_abs)
title("corrd abs")
xlabel("d")

d = find(corr_abs == max(corr_abs));

A_corr_syn = Ar(d:over:N*over+d-1);

scatterplot(A_corr_syn);

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

rec_train = A_Ed(1:Ntr);

z = conj(train).*rec_train;

Z = fft(z);
Z_abs = abs(Z);

CFO = find(Z_abs == max(Z_abs))/over;

error = CFO - DF

n = 1:N+M-1; % vector with length N
e = exp(-1i*(2*pi*CFO).*n/over); % effect of CFO
rk = A_Ed.*(e.'); % signal at the entrance of receiver

scatterplot(rk);

h = Estimate_Channel(An,1,Ntr,M-1,rk.');

ZF = ZF_Equalizer(h,L,M-1,Delta);

A_ZF = conv(rk,ZF);

A_est = A_ZF(Delta:N+Delta-1);

scatterplot(A_est);