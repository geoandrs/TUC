function [g, s, t] = ext_euc_alg_poly(a, b, p)
        
    % Initialize
    r0 = a; r1 = b;
    s0 = 1; s1 = 0;
    t0 = 0; t1 = 1;

    while any(r1 ~= 0)
        % r0 = divZp(r0,r0(1),p);
        % r1 = divZp(r1,r1(1),p);
        [q, r] = mydeconv(r0, r1, p);
        
        r = mod(r, p);
        
        r0 = r1; r1 = r;
        
        temp_s = convZp(q, s1, p);
        temp_t = convZp(q, t1, p);
        
        s = difZp(s0, temp_s, p);
        t = difZp(t0, temp_t, p);
        
        s0 = s1; s1 = s;
        t0 = t1; t1 = t;
    end

    g = r0; 
    s = s0; 
    t = t0; 

    if g(1) ~= 0 && p == 0
        leading_coeff = g(1);
        g = g / leading_coeff;
        s = s / leading_coeff;
        t = t / leading_coeff;
    elseif g(1) ~= 0 && p > 0
        leading_coeff = g(1);
        g = mod(g * invZp(leading_coeff, p), p);
        s = mod(s * invZp(leading_coeff, p), p);
        t = mod(t * invZp(leading_coeff, p), p);
    end

    g = remove_leading_zeros(g);
    s = remove_leading_zeros(s);
    t = remove_leading_zeros(t);

end