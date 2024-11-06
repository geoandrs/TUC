function [ X ] = bits_to_4_PAM( bit_seq, A)
    
    X = zeros(1,length(bit_seq/2));
    
    i = 1;
    for k = 1:2:length(bit_seq)
        
        if(bit_seq(k) == 0 && bit_seq(k+1) == 0)
            X(i) = 3*A;
        elseif(bit_seq(k) == 0 && bit_seq(k+1) == 1)
            X(i) = A;
        elseif(bit_seq(k) == 1 && bit_seq(k+1) == 1)
            X(i) = -A;
        elseif(bit_seq(k) == 1 && bit_seq(k+1) == 0)
            X(i) = -3*A;
        else
            disp("An error occupied in the bit string");
            return
        end
        i = i + 1;
    end
    
end

