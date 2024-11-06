clear 
close all
clc

%% exercise 9 - test with exercise of HW1

a = 36;
b = 97;

[g,s,t] = ext_euc_alg_int(a,b);

txt = "("+a+","+b+") = "+g;
disp(txt)

if a*s+b*t == g
    disp("Correct")
else
    disp("Not Correct")
end

%% exercise 10 - simple tests

x = [3 6]
y = [4 3]
p = 7

z_sum = sumZp(x,y,p)

z_dif = difZp(x,y,p)

z_opp = oppZp(x,p)

y = 5
z_mul = mulZp(x,y,p)

x = [1 2 3]
y = [4 3 5]
z_conv = convZp(x,y,p)

x = 3
z_inv = invZp(x,p)

x = [1 2 3]
y = 3
z_div = divZp(x,y,p)

%% exercise 11 - test of exercise 7 of HW2

x = [4 6 2 5 1]; 
y = [1 2 3]; 
p = 7

% x = a_n*x^n + ... a_1*x + a_0
% y = b_n*y^n + ... b_1*y + b_0
[q, r] = mydeconv(x(end:-1:1), y(end:-1:1), p);
q = q(end:-1:1)
r = r(end:-1:1)

tmp = convZp(q,y,p);
a_len = length(tmp);
b_len = length(r);
if a_len > b_len
    r = [r zeros(1,a_len-b_len)];
end
res = sumZp(tmp,r,p);
if all(x == res)
    disp("Correct")
end

% x = conv([1, 1], [1, 2, 1]); % (x+1)(x^2 + 2x + 1)
% y = conv([1, 1], [1, 3, 1]); % (x+1)(x^2 + 3x + 1)

x = [3 2 4 2 1];
y = [5 4 9 4 1];

% x = [1, 2, 0, 4]; % x^3 + 2x^2 + 4
% y = [1, 0, 3]; % x^2 + 3

p = 0;
[g1,s,t] = ext_euc_alg_poly(x(end:-1:1),y(end:-1:1),p);

a_tmp = convZp(x(end:-1:1),s,p);
b_tmp = convZp(y(end:-1:1),t,p);
tmp = sumZp(a_tmp,b_tmp,p);
tmp = remove_leading_zeros(tmp);

g = g1(end:-1:1)
s = s(end:-1:1)
t = t(end:-1:1)

if all(tmp == g1)
    disp("Correct")
end
