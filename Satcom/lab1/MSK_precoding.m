function [BER] = MSK_precoding(N,A,T,b,X_Q_minus1,X_minus1)

    msk_symbols = 2*(randn(N,1)>0)-1; % N msk symbols
    
    msk_code = zeros(N,1);
    msk_code(1) = msk_symbols(1);
    for i = 2:N
        msk_code(i) = msk_symbols(i)*msk_symbols(i-1);
    end

    % OQPSK in-phase and quadrature component
    [XI,XQ] = MSK_to_QPSK(N,msk_code,X_Q_minus1,X_minus1); 

    Z = A*T*(XI + 1i*XQ); % OQPSK symbols

    n = sqrt(b*T)*(randn(N/2,1)+1i*randn(N/2,1)); % AWGN noise

    Y = Z + n; % receiver input
    
    % detect OQPSK symbols at receiver
    det_qpsk = detect_QPSK(N/2,Y);
    
    % calculate msk symbols from the detected oqpsk symbols
    [xd,det_msk] = QPSK_to_MSK(N,det_qpsk,X_Q_minus1,X_minus1);
    
    % change the symbols because we've done precoding
    msk_decode = zeros(N,1);
    msk_decode(1) = det_msk(1)*xd;
    for i = 2:N
        msk_decode(i) = det_msk(i)*msk_decode(i-1);
    end
    
    % calculate bit error rate
    BER = 0;
    for i = 1:N
       if(sign(msk_symbols(i)) ~= sign(msk_decode(i)))
           BER = BER + 1;
       end
    end
end

