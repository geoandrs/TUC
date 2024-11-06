function [ X ] = bits_to_2PAM(b)
  
  for k = 1:length(b)
    
    if(b(k) == 0)
      X(k) = 1;
    elseif(b(k) == 1)
      X(k) = -1;
    else
      disp("An error occupied in the bit string");
      return
    end
  end
end
