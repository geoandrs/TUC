clear 
close all

A = 5;
T = 10^(-6); % MSK symbol period
N = 10^5; % MSK symbols -> 0.5*N QPSK symbols
X_Q_minus1 = -1; % initial value X_Q,-1 = -1
X_minus1 = 1; % initial value X_-1 = -1
snrdb = 5:12; % SNR(dB) for the simulation
snr = 10.^(snrdb/10); % SNR for error
% theoretical BER (aproximation of BPSK)
BER_est = (1/2).*erfc(sqrt(snr/2));
% theoretical BER of MSK based on calculations
BER_theory = 2*(BER_est-(BER_est.^2));

BER = zeros(1,length(snrdb));
i = 1;
for k = snr
    b = (T*(A^2))/k;
    BER(i) = BER(i)+MSK(N,A,T,b,X_Q_minus1,X_minus1);
    i = i + 1;
end
BER_no_precoding = BER/N; % bit error rate with no precoding

figure()
semilogy(snrdb,BER_no_precoding,'*')
hold on;
semilogy(snrdb,BER_est)
semilogy(snrdb,BER_theory)
hold off;
legend("No precoding","Estimation","Real")
xlabel("SNR(dB)")
ylabel("BER")