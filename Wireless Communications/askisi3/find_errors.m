function [errors] = find_errors(in, out)
    
    if ((sign(real(in)) ~= sign(real(out)))|(sign(imag(in)) ~= sign(imag(out))))
        errors = 1;
    else
        errors = 0;
    end

end

