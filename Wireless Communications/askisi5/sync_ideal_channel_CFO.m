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
theta = pi/8;
c = randn(1,1) + 1i*randn(1,1); % complex number to multiply channel


An = sign(randn(N,1))+1i*sign(randn(N,1)); % 4-QAM symbol sequence
train = An(1:Ntr); % training symbols

[phi,t] = srrc_pulse(T, over, B, b); % srrc pulse 

A = Fs*upsample(An,over); % upsample to have 1 symbol every over
td = linspace(0,N*T,N*over); % time for the input symbols

At = conv(c*A,phi)*Ts; % output after the srrc filter at transmitter

finish = td(end)+t(end);
tt = linspace(0,finish,length(At)); % time at transmitter

n = 1:length(At); % vector with length At
e = exp(1i*(2*pi*DFs).*n+theta); % effect of CFO
At_new = At.*(e.'); % signal at the entrance of receiver

Ar = conv(At_new,phi)*Ts; % output after srrc filter at receiver
finish = tt(end)+t(end);
tr = linspace(0,finish,length(Ar)); % time at receiver

% symbols after Synchronization based on energy
A_energy_syn = energy_syn(Ar,over,N,B); 

scatterplot(A_energy_syn); % plot the symbols at complex plane

% symbols after Synchronization based on corr sequence
A_corr_syn = corr_syn(N,B,over,Ntr,Ar,train); 

scatterplot(A_corr_syn); % plot the symbols at complex plane

% prepei na kanw to 2.4

rec_train = A_energy_syn(1:Ntr);

z = conj(train).*rec_train;

Z = fft(z);
Z_abs = abs(Z);

CFO = find(Z_abs == max(Z_abs))/over;

error = CFO - DF

n = 1:N; % vector with length N
e = exp(-1i*(2*pi*CFO).*n/over); % effect of CFO
rk = A_energy_syn.*(e.'); % signal at the entrance of receiver

scatterplot(rk);

h = Estimate_Channel(An,1,Ntr,0,rk.');

A_out = (conj(h)/norm(h))*rk;

scatterplot(A_out);