function [bit_err] = MRC(N,M,No)

    h = (randn(1, M) + 1i*randn(1, M));

    s = bits_to_4QAM(N);

    n = sqrt(No/2)*(randn(M,N) + 1i*randn(M,N));

    r = zeros(M,N);
    for k = (1:N)
        for m = (1:M)
            r(m,k) = h(m)*s(k) + n(m,k);
        end
    end
    
    detected_input = zeros(1, N);
    for k = (1:N)
        R = (conj(h)/norm(h))*r(:,k);
        Rr = real(R);
            if (sign(Rr) >= 0)
                re = 1;
            else
                re = -1;
            end

        Ri = imag(R);
            if (sign(Ri) >= 0)
                im = 1;
            else
                im = -1;
            end

        detected_input(k) = re + 1i*im;
    end

    bit_err = 0;
    for k = (1:N)
        if (sign(real(s(k))) ~= sign(real(detected_input(k))))
            bit_err = bit_err + 1;
        end

        if (sign(imag(s(k))) ~= sign(imag(detected_input(k))))
            bit_err = bit_err + 1;
        end
    end
    
end

