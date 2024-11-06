function [f1,f2,f3,f4] = SNR_functions(SNRdB)
    
    SNR = db2mag(2*SNRdB);
    f1 = zeros(1, length(SNRdB));
    f2 = zeros(1, length(SNRdB));
    f3 = zeros(1, length(SNRdB));
    f4 = zeros(1, length(SNRdB));
    for k = 1:length(SNRdB)
        f1(k) = 1/SNR(k);
        f2(k) = 1/(SNR(k))^2;
        f3(k) = 1/(SNR(k))^3;
        f4(k) = 1/(SNR(k))^4;
    end
    
end

