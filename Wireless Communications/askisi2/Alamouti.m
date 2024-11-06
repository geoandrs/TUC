function [biterror] = Alamouti(N,M,No)

    h = (randn(1, M) + 1i*randn(1, M));

    H0 = [h(1) h(2);conj(h(2)) -conj(h(1))];
    H = norm(h)*H0;

    s = bits_to_4QAM(N);
    s_alamouti = [s(1:N/2);s(N/2+1:N)];

    n = sqrt(No)*(randn(M,N/2) + 1i*randn(M,N/2));


    r = zeros(2,N/2);
    for k = 1:N/2

        r(:,k) = H0*s_alamouti(:,k)+n(:,k);

    end

    R = H'*r;

    biterror = 0;
    for k = 1:N/2
        if (sign(real(s_alamouti(1,k))) ~= sign(real(R(1,k))))
            biterror = biterror + 1;
        end

        if (sign(imag(s_alamouti(1,k))) ~= sign(imag(R(1,k))))
            biterror = biterror + 1;
        end

        if (sign(real(s_alamouti(2,k))) ~= sign(real(R(2,k))))
            biterror = biterror + 1;
        end

        if (sign(imag(s_alamouti(2,k))) ~= sign(imag(R(2,k))))
            biterror = biterror + 1;
        end
    end

end

