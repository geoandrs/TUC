function [biterr] = TB(N,M,No)

    h = (randn(1, M) + 1i*randn(1, M));

    s = bits_to_4QAM(N);

    s_tb = zeros(M,N);
    for k = 1:N
        s_tb(:,k) = (conj(h)/norm(h))*s(k);
    end
    
    n = sqrt(No/2)*(randn(1,N) + 1i*randn(1,N));

    r = h*s_tb + n;
    
    biterr = 0;
    for k = (1:N)
        if (sign(real(s(k))) ~= sign(real(r(k))))
            biterr = biterr + 1;
        end

        if (sign(imag(s(k))) ~= sign(imag(r(k))))
            biterr = biterr + 1;
        end
    end
    
end

