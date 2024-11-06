function [biterror] = Decorrelator(nt,nr,N,No)
    
    h = (randn(nt, nr) + 1i*randn(nt, nr));

    X = zeros(nt, N);
    for k = 1:nr
        X(k,:) = bits_to_4QAM(N);
    end

    W = sqrt(No/2)*(randn(nr,N) + 1i*randn(nr,N));

    Y = h*X + W;

    X_tilda = h\Y;

    x1 = 1+1i;
    x2 = 1-1i;
    x3 = -1+1i;
    x4 = -1-1i;
    x = [x1,x2,x3,x4];

    det_in = zeros(nr,N);


    for n = 1:N

        dist = zeros(nt,4);
        for k = 1:4

            dist(1,k) = abs(X_tilda(1,n)-x(k))^2;
            dist(2,k) = abs(X_tilda(2,n)-x(k))^2;

        end

        mdist1 = min(dist(1,:));
        mdist2 = min(dist(2,:));

        if dist(1,1) == mdist1
            det_in(1,n) = x(1);
        elseif dist(1,2) == mdist1
            det_in(1,n) = x(2);
        elseif dist(1,3) == mdist1
            det_in(1,n) = x(3);
        elseif dist(1,4) == mdist1
            det_in(1,n) = x(4);
        end

        if dist(2,1) == mdist2
            det_in(2,n) = x(1);
        elseif dist(2,2) == mdist2
            det_in(2,n) = x(2);
        elseif dist(2,3) == mdist2
            det_in(2,n) = x(3);
        elseif dist(2,4) == mdist2
            det_in(2,n) = x(4);
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

