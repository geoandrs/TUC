function z = difZp(x, y, p)
    % Ensure inputs are row vectors
    x = x(:).';
    y = y(:).';
    
    % Pad the shorter polynomial with zeros
    len_diff = length(x) - length(y);
    if len_diff > 0
        y = [zeros(1, len_diff), y];
    elseif len_diff < 0
        x = [zeros(1, -len_diff), x];
    end
    
    % Subtract polynomials
    z = x - y;
    
    % Apply modulus if p > 0
    if p > 0
        z = mod(z, p);
    end
end