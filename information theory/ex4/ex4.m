clear
close all

N = 1000000; % number of bits
p = 0.1; % probability of bit 1
res = H(p)
X = double(rand(1,N)<p);
Y = arithmetic_coder(X,p);
X_dec = arithmetic_decoder(Y,p,N);
ber = 0;
for kk = 1:N
    if abs(X_dec(kk) - X(kk)) == 1
        ber = ber + 1;
    end
end

length(Y)/N