function [XI,XQ] = MSK_to_QPSK(N,msk_symbols,X_Q_minus1,X_minus1)

    XI = zeros(N/2,1); % QPSK in-phase component
    XQ = zeros(N/2,1); % QPSK quadrature component

    % calculate OQPSK symbols from MSK symbols
    XI(1) = -X_Q_minus1*X_minus1;
    XQ(1) = -XI(1)*msk_symbols(1);
    for n = 2:N/2
        XI(n) = -XQ(n-1)*msk_symbols(2*(n-1));
        XQ(n) = -XI(n)*msk_symbols(2*(n-1)-1);
    end
    
end

