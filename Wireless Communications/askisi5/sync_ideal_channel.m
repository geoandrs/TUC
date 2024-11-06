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


An = sign(randn(N,1))+1i*sign(randn(N,1)); % 4-QAM symbol sequence
train = An(1:Ntr); % training symbols

[phi,t] = srrc_pulse(T, over, B, b); % srrc pulse 

A = Fs*upsample(An,over); % upsample to have 1 symbol every over
td = linspace(0,N*T,N*over); % time for the input symbols

At = conv(A,phi)*Ts; % output after the srrc filter at transmitter

finish = td(end)+t(end);
tt = linspace(0,finish,length(At)); % time at transmitter

figure() % plot real and imaginary of the signal at transmitter
subplot(211)
plot(tt,real(At))
subplot(212)
plot(tt,imag(At))

% the impulse response of our channel is c(t) = δ(t)
% so after the filter we will have the same signal At

Ar = conv(At,phi)*Ts; % output after srrc filter at receiver
finish = tt(end)+t(end);
tr = linspace(0,finish,length(Ar)); % time at receiver

figure() % plot real and imaginary of the signal at receiver
subplot(211)
plot(tr,real(Ar))
subplot(212)
plot(tr,imag(Ar))

ho = conv(phi,phi)*Ts; % composite impulse response of channel and
                       % srrc filters at transmitter and receiver
start = 0;
finish = t(end)+t(end);
tho = linspace(0,finish,length(ho)); % time for composite channel

figure() % plot absolute value of composite channel
plot(tho,abs(ho))
title("absolute value of composite channel");
xlabel("time")
grid on;

% symbols after Synchronization based on energy
A_energy_syn = energy_syn(Ar,over,N,B); 

figure() % plot energy sequence of synchronized symbols
plot(0:N-1,(abs(A_energy_syn)).^2)
title("Energy of output sequence")
grid on;

% symbols after Synchronization based on corr sequence
A_corr_syn = corr_syn(N,B,over,Ntr,Ar,train); 

scatterplot(A_corr_syn); % plot the symbols at complex plane

% Do the previous steps with c(t) = c*δ(t)

c = randn(1,1) + 1i*randn(1,1); % complex number to multiply channel
At = conv(c*A,phi)*Ts; % output after the srrc filter at transmitter

finish = td(end)+t(end);
tt = linspace(0,finish,length(At)); % time at transmitter

Ar = conv(At,phi)*Ts; % output after srrc filter at receiver
finish = tt(end)+t(end);
tr = linspace(0,finish,length(Ar)); % time at receiver

% symbols after Synchronization based on energy
A_energy_syn = energy_syn(Ar,over,N,B); 

% symbols after Synchronization based on corr sequence
A_corr_syn = corr_syn(N,B,over,Ntr,Ar,train); 

scatterplot(A_corr_syn);