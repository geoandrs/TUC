clear all
close all

%data
SNRdb = [0:2:16];
K = 1000;
N = 200;
M = 16; %τάξη του αστερισμού
bps = log2(M); %bits per symbol

symbols = N*K;
bits = bps*N*K;

PSNRs_err = zeros(1, length(SNRdb));
PSNRb_err = zeros(1, length(SNRdb));
theory_PSNRs_err = zeros(1, length(SNRdb));
theory_PSNRb_err = zeros(1, length(SNRdb));

i = 1;
for tmp_SNRdb = 0:2:16
    
    Ksymbol_errors = 0;
    Kbit_errors = 0;
    for j = 1:K
        
        [symbol_errors, bit_errors] = QAM_16(N, tmp_SNRdb);
        Ksymbol_errors = Ksymbol_errors + symbol_errors;
        Kbit_errors = Kbit_errors + bit_errors;
        symbol_errors = 0;
        bit_errors = 0;

    end
    PSNRs_err(i) = Ksymbol_errors/symbols;
    PSNRb_err(i) = Kbit_errors/bits;
    
    SNR = 10^(tmp_SNRdb/10);
    q = (3/2)*Q(sqrt(0.2*SNR));
    theory_PSNRs_err(i) = 1 - (1-q)^2;
    theory_PSNRb_err(i) = (1/bps)*theory_PSNRs_err(i);
    
    i = i + 1;
    
end  

figure();
semilogy(SNRdb, PSNRs_err);
hold on;
semilogy(SNRdb, theory_PSNRs_err, 'r');
hold off;

figure();
semilogy(SNRdb, PSNRb_err);
hold on;
semilogy(SNRdb, theory_PSNRb_err, 'r');
hold off;












