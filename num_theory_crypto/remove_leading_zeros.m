function trimmed = remove_leading_zeros(vec)
    % Define a small tolerance to identify numerical zeros
    tol = 1e-12;
    
    % Find the first non-zero element, considering the tolerance
    first_non_zero_idx = find(abs(vec) > tol, 1, 'first');
    
    % If all elements are zero, return zero
    if isempty(first_non_zero_idx)
        trimmed = 0;
    else
        % Trim the leading zeros
        trimmed = vec(first_non_zero_idx:end);
    end
end