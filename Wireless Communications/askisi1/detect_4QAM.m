function [detected_input] = detect_4QAM(N, y)

    detected_input = zeros(1, N);
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
        detected_input(k) = re + i*im;
        
    end

end

