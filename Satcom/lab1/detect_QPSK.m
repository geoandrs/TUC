function [detected_input] = detect_QPSK(N, y)

    detected_input = zeros(N,1);
    for k = (1:N)
        
        if (sign(real(y(k))) >= 0)
            re = 1;
        else
            re = -1;
        end
        
        if (sign(imag(y(k))) >= 0)
            im = 1;
        else
            im = -1;
        end
        detected_input(k) = re + 1i*im;
        
    end

end

