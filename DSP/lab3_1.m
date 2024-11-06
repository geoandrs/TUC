clear all
close all

fs = 10000;
Ts = 1/fs;
Nf = 2048;

wp = 2*pi*3000;
Rp = 3;
ws = 2*pi*4000;
Rs = 30;
Rs2 = 50;

[N, wc] = buttord(wp,ws,Rp,Rs,'s');

[Z,P,K] = buttap(N);

[num, den] = zp2tf(Z,P,K);

[numt, dent] = lp2lp(num, den, wc);

f = 0 : fs/(2*Nf) : fs/2 - fs/(2*Nf);
H1 = freqs(numt, dent, 2*pi*f);

[numd,dend] = bilinear(numt,dent,fs);

H2 = freqz(numd, dend, Nf);

figure();
plot(f,20*log(abs(H1)), '--r');
hold on;
plot(f,20*log(abs(H2)), 'b');
title("Butterworth (Rs = 30db)");
xlabel("F(Hz)");
ylabel("H(db)");
legend('Analog', 'Digital');
hold off;

[N2, wc2] = buttord(wp,ws,Rp,Rs2,'s');

[Z2,P2,K2] = buttap(N2);

[num2, den2] = zp2tf(Z2,P2,K2);

[numt2, dent2] = lp2lp(num2, den2, wc2);

f2 = 0 : fs/(2*Nf) : fs/2 - fs/(2*Nf);
H1_2 = freqs(numt2, dent2, 2*pi*f2);

[numd2,dend2] = bilinear(numt2,dent2,fs);

H2_2 = freqz(numd2, dend2, Nf);

figure();
plot(f2,20*log(abs(H1_2)), '--r');
hold on;
plot(f2,20*log(abs(H2_2)), 'b');
title("Butterworth (Rs = 50db)");
xlabel("F(Hz)");
ylabel("H(db)");
legend('Analog', 'Digital');
hold off;

%%%%%%%%%%%%%%%%%%   ask2 chebyshev

Ncheb1 = 2;
Ncheb2 = 16;

wc_cheb = 2;
Ts_cheb = 0.2;
Fs_cheb = 1/Ts_cheb;
Rp_cheb = 3;

ws_cheb = 2*pi*Fs_cheb;
wp_cheb = wc_cheb/(ws_cheb/2);
Mf = 256;

[num_cheb1, den_cheb1] = cheby1(Ncheb1, Rp_cheb, wp_cheb, 'high');
Hc1 = freqz(num_cheb1,den_cheb1,Mf);

[num_cheb2, den_cheb2] = cheby1(Ncheb2, Rp_cheb, wp_cheb, 'high');
Hc2 = freqz(num_cheb2,den_cheb2,Mf);

w = 0:1/Mf:1-1/Mf;
figure();
plot(w, 20*log(abs(Hc1)), '--r');
hold on;
plot(w, 20*log(abs(Hc2)), 'b');
title("Chebyshev Filters");
xlabel("Normalised Frequency");
ylabel("H(db)");
legend('N = 2', 'N = 16');
hold off;

%%%%%%%%%%%%%%%%%%% ask3a

Kf = 500;
n = 1:Kf;
x = 1+cos(1000*n*Ts)+cos(16000*n*Ts)+cos(30000*n*Ts);
figure;
stem(n,x);
ylabel("X[n]");
xlabel("n");


X = fftshift(fft(x));
f3a = -fs/2:fs/Kf:fs/2-fs/Kf;

figure;
stem(f3a,abs(X));
ylabel("|X(F)|");
xlabel("F(Hz)");

y = filter(numd,dend,x);
Y = fftshift(fft(y));
figure;
stem(f3a,abs(Y));
title("After Butterworth (Rs = 30db)")
ylabel("|Y(F)|");
xlabel("F(Hz)");

y2 = filter(numd2,dend2,x);
Y2 = fftshift(fft(y2));
figure;
stem(f3a,abs(Y2));
title("After Butterworth (Rs = 50db)")
ylabel("|Y(F)|");
xlabel("F(Hz)");

%%%%%%%%%%%%%%%%%%%% ask3b

Kf = 500;
n = 1:Kf;
x2 = 1+cos(1.5*n*Ts_cheb)+cos(5*n*Ts_cheb);
figure;
stem(n,x2);
ylabel("X[n]");
xlabel("n");

X2 = fftshift(fft(x2));
f3b = -Fs_cheb/2:Fs_cheb/Kf:Fs_cheb/2-Fs_cheb/Kf;

figure;
stem(f3b,abs(X2));
ylabel("|X(F)|");
xlabel("F(Hz)");

yb = filter(num_cheb2, den_cheb2,x2);
Yb = fftshift(fft(yb));
figure;
stem(f3b,abs(Yb));
title("After Chebyshev (N = 16)")
ylabel("|Y(F)|");
xlabel("F(Hz)");






