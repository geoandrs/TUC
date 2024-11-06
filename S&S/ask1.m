clear all
close all

n1 = [-27:27];
x1 = abs(1./n1).*exp(abs(n1/7));
x1(n1 == 0) = 1.2;
subplot(2,2,1)
stem(n1, x1)

n2 = [-12:7];
x2 = (n2 + 3).*((n2 + 3) >= 0);
subplot(2,2,2)
stem(n2, x2)

ny = [n1(1) + n2(1):n1(end) + n2(end)];
Y = conv(x1, x2);
subplot(2,2,3:4)
stem(ny, Y)