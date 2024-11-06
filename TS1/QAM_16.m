function [symbol_errors, bit_errors] = QAM_16(N, SNR)
    
    A = 1;
    a = 1;
    T = 0.01;
    over = 10;
    Ts = T/over;
    Fs = 1/Ts;
    F0 = 200;

    [phi, t] = srrc_pulse(T,over,A,a);
    td = linspace(0,N*T,N*over);

    b = (sign(randn(4*N,1))+1)/2;
    X = bits_to_4_PAM(b,A);
  
    Xi = X(1:N);
    Xq = X(N+1:2*N);

    Xdi = Fs*upsample(Xi,over);
    XI = conv(Xdi, phi)*Ts;
    Xdq = Fs*upsample(Xq,over);
    XQ = conv(Xdq, phi)*Ts;
    tx = linspace(td(1)+t(1),td(end)+t(end),length(XI));

    Ximod = 2*XI.*cos(2*pi*F0*tx);
    Xqmod = -2*XQ.*sin(2*pi*F0*tx);
    Xmod = Ximod + Xqmod;

    numerator = 10*(A^2);
    denominator = Ts*(10^(SNR/10));
    var_w = numerator/denominator;

    W = sqrt(var_w)*randn(1,length(Xmod));
    Xexit = Xmod + W;

    XIexit = Xexit.*cos(2*pi*F0*tx);
    XQexit = -Xexit.*sin(2*pi*F0*tx);

    Iexit = conv(XIexit, phi)*Ts;
    Qexit = conv(XQexit, phi)*Ts;
    txexit = linspace(tx(1)+t(1),tx(end)+t(end),length(Iexit));
    
    Y = zeros(2,N);

    j = 1;
    for i = 2*A*over:over:length(txexit)-2*A*over-1
    
        Y(1,j) = Iexit(i);
        Y(2,j) = Qexit(i);
        j = j + 1;
    
    end
    
    est_XI = detect_4_PAM(Y(1,:),A);
    est_XQ = detect_4_PAM(Y(2,:),A);

    symbol_errors = 0;

    for i = 1:N

        if(est_XI(i) ~= Xi(i) || est_XQ(i) ~= Xq(i))
            symbol_errors = symbol_errors + 1;
        end

    end

    Xn = [est_XI est_XQ];
    est_bit = PAM_4_to_bits(Xn,A);

    bit_errors = 0;
    for i = 1:length(b)
        
        if(est_bit(i) ~= b(i))
            bit_errors = bit_errors + 1;
        end
        
    end
    
end

