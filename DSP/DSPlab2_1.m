clear all
close all

fs = 1;
ts = 1/fs;
a = [0.2 0];
b1 = [1 -0.7 -0.18];
b2 = [1 -1];
b = conv(b1, b2);

h1 = tf(a,b1,ts);
h2 = tf(a,b,ts);

r = 0;
p = [-0.2; 0.9];
zplane(r,p)

f = -pi:pi/128:pi;
figure();
freqz(a, b1, f)
title("me 3o orisma xwris extra polo")

figure();
freqz(a, b1)
title("xwris 3o orisma xwris extra polo")

figure();
freqz(a, b, f)
title("me 3o orisma me extra polo")

figure();
freqz(a, b)
title("xwris 3o orisma me extra polo")


