function [real_errors, imag_errors, bit_errors] = find_errors(N, s, detected_input)
    
    real_errors = zeros(1, N);
    imag_errors = zeros(1, N);
    bit_errors = 0;
    for k = (1:N)
   
        if (sign(real(s(k))) ~= sign(real(detected_input(k))))
            real_errors(k) = 1;
            bit_errors = bit_errors + 1;
        end

        if (sign(imag(s(k))) ~= sign(imag(detected_input(k))))
            imag_errors(k) = 1;
            bit_errors = bit_errors + 1;
        end

    end

end

