clear 
close all

% data

A = 5;
T = 10^(-6); % MSK symbol period
N = 10^7; % MSK symbols
X_Q_minus1 = -1; % initial value X_Q,-1 = -1
X_minus1 = 1; % initial value X_-1 = -1
snrdb = 5:12; % SNR(dB) for the simulation
snr = 10.^(snrdb/10); % SNR for error

phi_start = 0; % phase of the first symbol

% theoretical BER (aproximation of BPSK)
BER_est = (1/2).*erfc(sqrt(snr/2));
% theoretical BER of MSK based on calculations
BER_theory = 2*(BER_est-(BER_est.^2));

% 2 vector to help us
in_pos = [A*sqrt(T) ; 0]; % input xn = +1
in_neg = (1/pi)*A*sqrt(T)*[-2i ; sqrt(pi^2-4)]; % input xn = -1
vin = [in_pos, in_neg];

% code

BER = zeros(2,length(snrdb));
i = 1;
for k = snr
    b = (T*(A^2))/k;
    BER(1,i) = MSK_Viterbi(N,b,phi_start,vin);
    BER(2,i) = MSK(N,A,T,b,X_Q_minus1,X_minus1);
    i = i + 1;
end

figure()
semilogy(snrdb,BER(1,:),'*')
hold on;
semilogy(snrdb,BER(2,:),'square')
semilogy(snrdb,BER_theory)
semilogy(snrdb,BER_est)
hold off;
legend("Viterbi","MSK as OQPSK","Real","Estimation")
xlabel("SNR(dB)")
ylabel("BER")
