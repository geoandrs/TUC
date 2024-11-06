clear all
close all

N = 200;
M = 2; 
K = 100000;
SNRdB = 0:2:20;

% No = 1/2;
% berr = MRC(N,M,No);


SNR = db2mag(2*SNRdB);
biterror1 = zeros(1, length(SNRdB));
biterror2 = zeros(1, length(SNRdB));
for k = 1:length(SNRdB)
    em = sqrt(SNR(k)/(1+SNR(k)));
    a = ((1-em)/2)^M;
    b = (1+em)/2;
    for m = 0:(M-1)
        biterror1(k) = biterror1(k)+(nchoosek(M-1+m, m)*b^m);
    end
    biterror1(k) = a*biterror1(k);
    
    biterror2(k) = nchoosek(2*M-1, M)*(1/((4^M)*(SNR(k)^M)));
end


total_BER = zeros(1, length(SNRdB));
v = 1;
berr = 0;
for tmpSNRdB = 0:2:20
    
    for k = 1:K
        
        
        No = 2/db2mag(2*tmpSNRdB);
        
        [berr] = MRC(N,M,No);
    
        total_BER(v) = total_BER(v) + berr;
        
    end
    v = v + 1;
end
BER_MRC = total_BER/(2*N*K);


figure();
semilogy(SNRdB, biterror1)
hold on;
semilogy(SNRdB, biterror2, 'r')
semilogy(SNRdB, BER_MRC, 'g')
xlabel("SNR (dB)")
ylabel("BER")
legend("BER approximation", "BER approximation high SNR", "Experimental BER")
grid on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% No = 1/2;
% [biterr] = TB(N,M,No);

total_BER = zeros(1, length(SNRdB));
v = 1;
biterr = 0;
for tmpSNRdB = 0:2:20
    
    for k = 1:K
        
        
        No = 2/db2mag(2*tmpSNRdB);
        
        [biterr] = TB(N,M,No);
    
        total_BER(v) = total_BER(v) + biterr;
        
    end
    v = v + 1;
end
BER_TB = total_BER/(2*N*K);

figure();
semilogy(SNRdB, BER_TB)
hold on;
semilogy(SNRdB, BER_MRC, 'r')
xlabel("SNR (dB)")
ylabel("BER")
legend("BER TB", "BER MRC")
grid on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

% No = 1/2;
% [biterror] = Alamouti(N,M,No);

total_BER = zeros(1, length(SNRdB));
v = 1;
biterror = 0;
for tmpSNRdB = 0:2:20
    
    for k = 1:K
        
        No = 2/db2mag(2*tmpSNRdB);

        [biterror] = Alamouti(N,M,No);
    
        total_BER(v) = total_BER(v) + biterror;
        
    end
    v = v + 1;
end
BER_Alamouti = total_BER/(2*N*K);

figure();
semilogy(SNRdB, BER_TB)
hold on;
semilogy(SNRdB, BER_MRC, 'r')
semilogy(SNRdB, BER_Alamouti, 'g')
xlabel("SNR (dB)")
ylabel("BER")
legend("BER TB", "BER MRC", "BER Alamouti")
grid on;
hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


nt = 2; % number of antennas at transmitter
nr = 2; % number of antennas at receiver

% No = 1/2;
% [biterror] = spatial_multiplexing_4QAM(nt,nr,N,No);

total_BER = zeros(1, length(SNRdB));
v = 1;
biterror = 0;
for tmpSNRdB = 0:2:20
    
    for k = 1:K
        
        No = 2/db2mag(2*tmpSNRdB);

        [biterror] = spatial_multiplexing_4QAM(nt,nr,N,No);
    
        total_BER(v) = total_BER(v) + biterror;
        
    end
    v = v + 1;
end
BER_SMULT = total_BER/(2*N*K);

SNR1 = zeros(1, length(SNRdB));
SNR2 = zeros(1, length(SNRdB));
for k = 1:length(SNRdB)
    SNR1(k) = 1/db2mag(2*SNRdB(k));
    SNR2(k) = 1/(db2mag(2*SNRdB(k)))^2;
end

figure();
semilogy(SNRdB, BER_SMULT)
hold on;
semilogy(SNRdB, SNR1, 'r')
semilogy(SNRdB, SNR2, 'g')
xlabel("SNR (dB)")
ylabel("BER")
legend("BER Spatial Multiplexing", "1/SNR", "1/SNR^2")
grid on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% No = 1/2;
% [biterror] = Decorrelator(nt,nr,N,No);

total_BER = zeros(1, length(SNRdB));
v = 1;
biterror = 0;
for tmpSNRdB = 0:2:20
    
    for k = 1:K
        
        No = 2/db2mag(2*tmpSNRdB);

        [biterror] = Decorrelator(nt,nr,N,No);
    
        total_BER(v) = total_BER(v) + biterror;
        
    end
    v = v + 1;
end
BER_DEC = total_BER/(2*N*K);

figure();
semilogy(SNRdB, SNR1)
hold on;
semilogy(SNRdB, SNR2, 'r')
semilogy(SNRdB, BER_DEC, 'g')
xlabel("SNR (dB)")
ylabel("BER")
legend("1/SNR", "1/SNR^2", "BER Decorrelator")
grid on;
hold off;


