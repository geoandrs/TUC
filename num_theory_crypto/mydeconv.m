function [q, r] = mydeconv(a, b, p)
        % Ensure inputs are row vectors
    a = a(:).';
    b = b(:).';

    % Degree of polynomials
    deg_a = length(a) - 1;
    deg_b = length(b) - 1;

    % Initialize quotient and remainder
    q = zeros(1, max(deg_a - deg_b + 1, 1));
    r = a;

    % Perform polynomial long division
    while length(r) >= length(b) && any(r ~= 0)
        % Leading coefficient of remainder
        lead_coeff_r = r(1);

        % Leading coefficient of divisor
        lead_coeff_b = b(1);

        % Division in real numbers
        lead_coeff_q = mod(lead_coeff_r * invZp(lead_coeff_b, p), p);

        % Quotient term
        q_term = [lead_coeff_q, zeros(1, length(r) - length(b))];
        q(length(q) - length(q_term) + 1 : end) = mod(q(length(q) - length(q_term) + 1 : end) + q_term,p);

        % Subtract the appropriate multiple of b from r
        b_shifted = [b, zeros(1, length(r) - length(b))];
        r = mod(r - lead_coeff_q * b_shifted,p);

        r = remove_leading_zeros(r);

        % Apply modulus if p > 0
        if p > 0
            r = mod(r, p);
        end
    end
    
    % Ensure quotient and remainder are valid
    if isempty(q)
        q = 0;
    end
    if isempty(r)
        r = 0;
    end
end