clear all
close all

Wc = 0.4*pi;
Fc = Wc/(2*pi);
Fs = 0.1*10^3;
Ws = 2*pi*Fs;
N = 21;

wc = Wc/(Ws/2);

filter1 = fir1(N-1, wc, rectwin(N));
filter2 = fir1(N-1, wc, hamming(N));

[H1, w1] = freqz(filter1,N);
figure();
plot(w1, abs(H1));

[H2, w2] = freqz(filter2,N);
figure();
plot(w2, abs(H2));

figure();
plot(w1, abs(H1));
hold on;
plot(w2, abs(H2), 'r');
xlabel("ω rad/sample");
ylabel("|H(z)|");
legend("Rectangular","Hamming")
hold off;











