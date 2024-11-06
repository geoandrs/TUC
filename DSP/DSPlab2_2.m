clear all 
close all

syms z
a = [4 -3.5];
b = [1 -2.5 1];

[r,p,k] = residuez(a,b)

H1 = r(1)/(1 - p(1)*z^(-1));
H2 = r(2)/(1 - p(2)*z^(-1));
H = H1 + H2;
pretty(H)
Hz = iztrans(H)