function [biterror] = spatial_multiplexing_4QAM(nt,nr,N,No)
    
    h = (randn(nt, nr) + 1i*randn(nt, nr));


    X = zeros(nt, N);
    for k = 1:nr
        X(k,:) = bits_to_4QAM(N);
    end

    W = sqrt(No/2)*(randn(nr,N) + 1i*randn(nr,N));

    Y = h*X + W;

    x1 = 1+1i;
    x2 = 1-1i;
    x3 = -1+1i;
    x4 = -1-1i;
    symbols_4QAM = [x1,x2,x3,x4];
    
    x = zeros(nr,16);
    
    p = 1;
    for k = 1:4
        for l = 1:4
            x(:,p) = [symbols_4QAM(k);symbols_4QAM(l)];
            p = p+1;
        end
    end
    
    dist = zeros(1,16);
    det_in = zeros(nr,N);
    for n = 1:N    

        for k = 1:16

            dist(k) = norm(Y(:,n)-h*x(:,k))^2;

        end

        mdist = min(dist);
        if dist(1) == mdist
            det_in(:,n) = x(:,1);
        elseif dist(2) == mdist
            det_in(:,n) = x(:,2);
        elseif dist(3) == mdist
            det_in(:,n) = x(:,3);
        elseif dist(4) == mdist
            det_in(:,n) = x(:,4);
        elseif dist(5) == mdist
            det_in(:,n) = x(:,5);
        elseif dist(6) == mdist
            det_in(:,n) = x(:,6);
        elseif dist(7) == mdist
            det_in(:,n) = x(:,7);
        elseif dist(8) == mdist
            det_in(:,n) = x(:,8);
        elseif dist(9) == mdist
            det_in(:,n) = x(:,9);
        elseif dist(10) == mdist
            det_in(:,n) = x(:,10);
        elseif dist(11) == mdist
            det_in(:,n) = x(:,11);
        elseif dist(12) == mdist
            det_in(:,n) = x(:,12);
        elseif dist(13) == mdist
            det_in(:,n) = x(:,13);
        elseif dist(14) == mdist
            det_in(:,n) = x(:,14);
        elseif dist(15) == mdist
            det_in(:,n) = x(:,15);
        elseif dist(16) == mdist
            det_in(:,n) = x(:,16);
        end

    end

    biterror = 0;
    for k = 1:N
        if (sign(real(det_in(1,k))) ~= sign(real(X(1,k))))
            biterror = biterror + 1;
        end
        if (sign(imag(det_in(1,k))) ~= sign(imag(X(1,k))))
            biterror = biterror + 1;
        end
        if (sign(real(det_in(2,k))) ~= sign(real(X(2,k))))
            biterror = biterror + 1;
        end
        if (sign(imag(det_in(2,k))) ~= sign(imag(X(2,k))))
            biterror = biterror + 1;
        end
    end


end

