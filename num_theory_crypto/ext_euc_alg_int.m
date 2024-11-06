function [g, s, t] = ext_euc_alg_int(a, b)

    % Initialize values
    old_r = a; r = b;
    old_s = 1; s = 0;
    old_t = 0; t = 1;

    % Perform the algorithm
    while r ~= 0
        quotient = floor(old_r / r);
        [old_r, r] = deal(r, old_r - quotient * r);
        [old_s, s] = deal(s, old_s - quotient * s);
        [old_t, t] = deal(t, old_t - quotient * t);
    end

    % Results
    g = old_r;
    s = old_s;
    t = old_t;


end

