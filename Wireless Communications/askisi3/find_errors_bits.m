function [errors] = find_errors_bits(in, out)
    
    errors = 0;
    
    if (sign(real(in)) ~= sign(real(out)))
        errors = errors + 1;
    end
    
    if (sign(imag(in)) ~= sign(imag(out)))
        errors = errors + 1;
    end

end

