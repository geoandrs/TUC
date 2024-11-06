function z = invZp(x, p)
    if p == 0
        % If x is a scalar (real number)
        if isscalar(x)
            if x == 0
                error('Inverse does not exist for zero.');
            else
                z = 1 / x;
            end
        else
            % If x is a polynomial (we consider only constant polynomials)
            if length(x) == 1
                if x == 0
                    error('Inverse does not exist for zero polynomial.');
                else
                    z = 1 / x;
                end
            else
                error('Inverse for non-constant polynomials does not exist in the polynomial ring.');
            end
        end
    else
        % Original code for p > 0 (modular arithmetic)
        [g, s, ~] = ext_euc_alg_int(x, p);
        if g ~= 1
            error('Inverse does not exist in Zp.');
        else
            z = mod(s, p);
        end
    end
end