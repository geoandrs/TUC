function [ est_bit ] = PAM_4_to_bits(X, A)
    
    est_bit = zeros(1, 2*length(X));
    
    j = 1;
    for i = 1:length(X)
        
        if(X(i) == 3*A)
            est_bit(j) = 0;
            est_bit(j+1) = 0;
        elseif(X(i) == A)
            est_bit(j) = 0;
            est_bit(j+1) = 1;
        elseif(X(i) == -A)
            est_bit(j) = 1;
            est_bit(j+1) = 1;
        elseif(X(i) == -3*A)
            est_bit(j) = 1;
            est_bit(j+1) = 0;
        else
            disp("An error occupied in the bit string");
            return
        end
        j = j + 2;
        
    end

end

