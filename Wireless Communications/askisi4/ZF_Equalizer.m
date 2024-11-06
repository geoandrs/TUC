function [fZF] = ZF_Equalizer(hls,order,K,Delta)

    Hrow = zeros(1,order+1);
    Hrow(1) = hls(1);
    Hcol = zeros(K+order+2,1);
    Hcol(1:K+1) = hls;
    H = toeplitz(Hcol,Hrow); % toeplitz matrix for Zero Forcing Equalizer
                             % based on the estimated channel

    edelta = zeros(K+order+2,1);
    edelta(Delta) = 1; % vector for wanted delay

    fZF = pinv(H)*edelta; % ZF Equalizer
    
end

