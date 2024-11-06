function [h] = flat_fading_channel(N, b)
    
    var_e = 1 - (b^2);

    e = sqrt(var_e)*(randn(N, 1) + i*randn(N, 1));

    h = zeros(1, N);
    h(1) = 1;

    for k = (1:N-1)

        h(k+1) = b*h(k) + e(k);

    end
    
end

