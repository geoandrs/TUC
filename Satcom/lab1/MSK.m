function [BER] = MSK(N,A,T,b,X_Q_minus1,X_minus1)

    msk_symbols = 2*(randn(N,1)>0)-1; % N msk symbols

    % QPSK in-phase and quadrature component
    [XI,XQ] = MSK_to_QPSK(N,msk_symbols,X_Q_minus1,X_minus1); 

    Z = A*T*(XI + 1i*XQ); % QPSK symbols

    n = sqrt(b*T)*(randn(N/2,1)+1i*randn(N/2,1)); % AWGN noise

    Y = Z + n; % receiver input

    det_qpsk = detect_QPSK(N/2,Y); % detect qpsk symbols

    [xd,det_msk] = QPSK_to_MSK(N,det_qpsk,X_Q_minus1,X_minus1);

    BER = 0;
    for i = 1:N

       if(sign(msk_symbols(i)) ~= sign(det_msk(i)))
           BER = BER + 1;
       end

    end
    
end

