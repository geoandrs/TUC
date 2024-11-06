clear all
close all

n1 = [-12:16];
x1 = n1/2;
x1(n1 >= 3) = exp((n1(n1 >= 3)/3).^2);
x1(n1 > 4) = 12*exp(-n1(n1 > 4)/7);
subplot(2,2,1)
stem(n1, x1)

n2 = [-4:7];
x2 = exp(abs(n2/3));
subplot(2,2,2)
stem(n2, x2)

ny = [n1(1) + n2(1):n1(end) + n2(end)];
Y = conv(x1, x2);
subplot(2,2,3:4)
stem(ny, Y)