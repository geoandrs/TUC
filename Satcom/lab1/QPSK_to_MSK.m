function [X_minus1,msk_symbols] = QPSK_to_MSK(N,qpsk_symbols,X_Q_minus1,X_minus1)
    
    XId = real(qpsk_symbols); % in-phase component
    XQd = imag(qpsk_symbols); % quadrature component
    
    % calculate MSK symbols from QPSK symbols
    msk_symbols = zeros(N,1);
    X_minus1 = -X_Q_minus1*XId(1);
    msk_symbols(1) = -XQd(1)*XId(1);
    for k = 2:N/2

        msk_symbols(2*(k-1)) = -XQd(k-1)*XId(k);
        msk_symbols(2*(k-1)-1) = -XQd(k)*XId(k);

    end
end

