clear all
close all

M = 10000;
N = 128; % N = [32 64 128];
L = 3;
SNRdB = 0:2:20;

[f1,f2,f3,~] = SNR_functions(SNRdB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ck = (1/sqrt(N))*sign(randn(1,N));
% 
% total_BER = zeros(1,length(SNRdB));
% u = 1;
% for tmpSNRdB = 0:2:20
%     
%     for m = 1:M
%         
%         var_w = 1/db2mag(tmpSNRdB);
%         
%         berr = Rake_1user(L,N,ck,var_w);
%         
%         total_BER(u) = total_BER(u) + berr; 
%         
%     end
%     u = u + 1;
% end
% BER_RAKE_1u = total_BER/(N*M);
% 
% figure();
% semilogy(SNRdB, BER_RAKE_1u)
% hold on;
% semilogy(SNRdB, f1, 'r')
% semilogy(SNRdB, f2, 'g')
% semilogy(SNRdB, f3, 'y')
% xlabel("SNR (dB)")
% ylabel("BER")
% legend("Rake 1 user L fingers", "1/SNR", "1/SNR^2", "1/SNR^3")
% grid on;
% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

total_BER = zeros(1,length(SNRdB));
u = 1;
for tmpSNRdB = 0:2:20
    
    for m = 1:M
        
        var_w = 1/db2mag(tmpSNRdB);
        
        berr = Rake_1finger_1user(L,N,ck,var_w);
        
        total_BER(u) = total_BER(u) + berr; 
        
    end
    u = u + 1;
end
BER_RAKE_1f1u = total_BER/(N*M);

figure();
semilogy(SNRdB, BER_RAKE_1f1u)
hold on;
semilogy(SNRdB, f1, 'r')
semilogy(SNRdB, f2, 'g')
semilogy(SNRdB, f3, 'y')
xlabel("SNR (dB)")
ylabel("BER")
legend("Rake 1 user 1 finger", "1/SNR", "1/SNR^2", "1/SNR^3")
grid on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = 2;
SNRdB = 0:2:16;

[f1,f2,f3] = SNR_functions(SNRdB);

c = zeros(K,N);
for k = 1:K
   c(k,:) = (1/sqrt(N))*sign(randn(1,N)); 
end

berr = 0;
total_BER = zeros(1,length(SNRdB));
u = 1;
for tmpSNRdB = 0:2:16
   
    for m = 1:M
       
        var_w = 1/db2mag(tmpSNRdB);
        
        berr = Rake_kusers(N,K,L,c,var_w);
        
        total_BER(u) = total_BER(u) + berr; 
        
    end
    u = u+1;
    
end
BER_RAKE_ku = total_BER/(N*M);

figure();
semilogy(SNRdB, BER_RAKE_ku)
hold on;
semilogy(SNRdB, f1, 'r')
semilogy(SNRdB, f2, 'g')
semilogy(SNRdB, f3, 'y')
xlabel("SNR (dB)")
ylabel("BER")
legend("Rake 2 users L fingers", "1/SNR", "1/SNR^2", "1/SNR^3")
grid on;
hold off;