function [detected_input] = detect_4QAM_atFFC(N, h, r)

    detected_input = zeros(1, N);
    for k = (1:N)
        
        R = (conj(h(k))/abs(h(k)))*r(k);
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
        detected_input(k) = re + i*im;
    end
end

