function [BER] = MSK_Viterbi(N,b,sphi,vin)
    
    sym = 2*(randn(N,1)>0)-1; % N msk symbols -> {+-1}

    r = zeros(2,N);
    w = zeros(4,1);
    trellis = zeros(2,4,N);
    phi = zeros(N+1,1);

    phi(1) = sphi;
    n = sqrt(b)*(randn(2,N)+1i*randn(2,N)); % AWGN noise

    r(:,1) = vin(:,(sym(1)<0)+1)*exp(1i*phi(1)) + n(:,1);
    phi(2) = phi(1)+sym(1)*(pi/2); 
    if phi(2) > 3*pi/2
        phi(2) = 0;
    elseif phi(2) < 0
        phi(2) = 3*pi/2;
    end
    w(1) = real(r(:,1)'*vin(:,1));
    w(4) = real(r(:,1)'*vin(:,2));
    trellis(1,:,1) = w;
    trellis(2,:,1) = [0;1;0;-1];

    for p = 2:N

        r(:,p) = vin(:,(sym(p)<0)+1)*exp(1i*phi(p)) + n(:,p);

        phi(p+1) = phi(p)+sym(p)*(pi/2); 

        if phi(p+1) > 3*pi/2
            phi(p+1) = 0;
        elseif phi(p+1) < 0
            phi(p+1) = 3*pi/2;
        end

        w = zeros(4,1);
        v = r(:,p)'*vin;
        if mod(p,2) == 1
            w(1:2) = real(v);
            w(3:4) = real(exp(1i*pi)*v);

            if trellis(1,1,p-1)+w(1) >= trellis(1,3,p-1)+w(4)
                trellis(1,2,p) = trellis(1,1,p-1)+w(1);
                trellis(2,2,p) = 1;
            else
                trellis(1,2,p) = trellis(1,3,p-1)+w(4);
                trellis(2,2,p) = -1;
            end
            if trellis(1,1,p-1)+w(2) >= trellis(1,3,p-1)+w(3)
                trellis(1,4,p) = trellis(1,1,p-1)+w(2);
                trellis(2,4,p) = -1;
            else
                trellis(1,4,p) = trellis(1,3,p-1)+w(3);
                trellis(2,4,p) = 1;
            end
        else
            w(1:2) = real(exp(1i*pi/2)*v);
            w(3:4) = real(exp(3i*pi/2)*v);
            if trellis(1,2,p-1)+w(2) >= trellis(1,4,p-1)+w(3)
                trellis(1,1,p) = trellis(1,2,p-1)+w(2);
                trellis(2,1,p) = -1;
            else
                trellis(1,1,p) = trellis(1,4,p-1)+w(3);
                trellis(2,1,p) = 1;
            end
            if trellis(1,2,p-1)+w(1) >= trellis(1,4,p-1)+w(4)
                trellis(1,3,p) = trellis(1,2,p-1)+w(1);
                trellis(2,3,p) = 1;
            else
                trellis(1,3,p) = trellis(1,4,p-1)+w(4);
                trellis(2,3,p) = -1;
            end
        end
    end

    max_sym = find(trellis(1,:,N) == max(trellis(1,:,N)));
    det_msk = zeros(1,N);
    BER = 0;
    for k = N:-1:1

        det_msk(k) = trellis(2,max_sym,k);
        if trellis(2,max_sym,k) > 0
            if max_sym == 1
                max_sym = 4;
            else
                max_sym = max_sym-1;
            end
        else
            if max_sym == 4
                max_sym = 1;
            else
                max_sym = max_sym+1;
            end
        end
        if(sign(sym(k)) ~= sign(det_msk(k)))
            BER = BER + 1;
        end
    end
    BER = BER/N;
end

