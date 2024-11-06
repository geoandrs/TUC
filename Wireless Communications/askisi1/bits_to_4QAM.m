function [ X ] = bits_to_4QAM(N)
  
    bits = (sign(randn(2*N,1))+1)/2;
    input = bits_to_2PAM(bits);

    inputi = input(1:N);
    inputq = input(N+1:2*N);

    X = inputi + i*inputq;
    
end