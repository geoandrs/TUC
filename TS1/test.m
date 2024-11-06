clear all
close all

%A1
T = 0.01;
over = 10;
A = 4;
a = [0 0.5 1];
Ts = T/over;

% A, T same for the 3 signals so 
% the time will be the same for the 3 of them
[phi1,t1] = srrc_pulse(T, over, A, a(1));
[phi2,t2] = srrc_pulse(T, over, A, a(2));
[phi3,t3] = srrc_pulse(T, over, A, a(3));

figure(1);
plot(t1,phi1);
hold on;
plot(t2,phi2,"r");
plot(t3,phi3,"g");
grid on;
legend("a = 0", "a = 0.5", "a = 1");
xlabel("Time (sec)");
ylabel("SRRC pulses");
hold off;

%A2
Nf = 1024; %Nf = 2048
Fs = 1/Ts;
f = [-Fs/2:Fs/Nf:Fs/2-Fs/Nf];
phiF1 = fftshift(fft(phi1,Nf)*Ts);
phiF2 = fftshift(fft(phi2,Nf)*Ts);
phiF3 = fftshift(fft(phi3,Nf)*Ts);

figure(2);
plot(f,abs(phiF1).^2);
hold on;
plot(f,abs(phiF2).^2,"r");
plot(f,abs(phiF3).^2,"g");
grid on;
title("Energy spectrum of SRRC pulses with plot");
legend("a = 0", "a = 0.5", "a = 1");
xlabel("Frequency (Hz)");
ylabel("Energy spectrum");
hold off;

figure(3);
semilogy(f,abs(phiF1).^2);
hold on;
semilogy(f,abs(phiF2).^2,"r");
semilogy(f,abs(phiF3).^2,"g");
title("Energy spectrum of SRRC pulses with semilogy");
legend("a = 0", "a = 0.5", "a = 1");
xlabel("Frequency (Hz)");
ylabel("Energy spectrum");
hold off;

%A3
c1 = T/10^3 * ones(1, length(f));
c2 = T/10^5 * ones(1, length(f));

figure(4);
semilogy(f,abs(phiF1).^2);
hold on;
semilogy(f,abs(phiF2).^2,"r");
semilogy(f,abs(phiF3).^2,"g");
semilogy(f,c1,"y");
semilogy(f,c2,"k");
title("Energy spectrum of SRRC pulses with BW lines");
legend("a = 0", "a = 0.5", "a = 1", "c1 = T/10^3", "c2 = T/10^5");
xlabel("Frequency (Hz)");
ylabel("Energy spectrum");
hold off;



