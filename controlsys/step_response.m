clear
close all

s = zpk('s');

G = 1/((s+1)^2);
figure()
step(G)
grid

G = 1/((2*s+1)^2);
figure()
step(G)
grid

G = 1/((s+1)*(5*s+1));
figure()
step(G)
grid

G = 1/((0.1*s+1)*(10*s+1));
figure()
step(G)
grid