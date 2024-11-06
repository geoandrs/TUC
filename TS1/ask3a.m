clear all
close all

% data 

N = 200;
A = 1;
a = 1;
T = 0.01;
over = 10;
Ts = T/over;
Fs = 1/Ts;
NFFT = 4096;
f = -Fs/2 : Fs/NFFT : Fs/2 - Fs/NFFT;
F0 = 200;
SNR = 20; %10

[phi, t] = srrc_pulse(T,over,A,a);
td = linspace(0,N*T,N*over);

%A1
b = (sign(randn(4*N,1))+1)/2;

%A2
% αφού χρησιμοποιούμε την αναπαράσταση 4PAM τότε το μήκος
% των bit από 4Ν γίνεται 2Ν 
X = bits_to_4_PAM(b,A);

%A3
% αφού μετατρέψαμε τα bits σε 4-PAM τότε χρειάζεται μόνο 
% να τα βάλουμε σε 2 νέες μεταβλητές  
Xi = X(1:N);
Xq = X(N+1:2*N);

%A4

Xdi = Fs*upsample(Xi,over);
XI = conv(Xdi, phi)*Ts;

tx = linspace(td(1)+t(1),td(end)+t(end),length(XI));
T_total = length(tx)*Ts;

figure();
plot(tx, XI);
xlabel("time");
title("Xi after filter");

Fxi = fftshift(fft(XI,NFFT)*Ts);
Pxi_numerator = abs(Fxi).^2;
Pxi = Pxi_numerator/T_total;

figure();
plot(f,Pxi);
xlabel("frequency");
title("Periodogram of Xi after filter");

Xdq = Fs*upsample(Xq,over);
XQ = conv(Xdq, phi)*Ts;

figure();
plot(tx, XQ);
xlabel("time");
title("Xq after filter");

Fxq = fftshift(fft(XQ,NFFT)*Ts);
Pxq_numerator = abs(Fxq).^2;
Pxq = Pxq_numerator/T_total;

figure();
plot(f,Pxq);
xlabel("frequency");
title("Periodogram of Xq after filter");

%A5
Ximod = 2*XI.*cos(2*pi*F0*tx);

figure();
plot(tx, Ximod);
xlabel("time");
title("Ximod");

Fximod = fftshift(fft(Ximod,NFFT)*Ts);
Pximod_numerator = abs(Fximod).^2;
Pximod = Pximod_numerator/T_total;

figure();
plot(f,Pximod);
xlabel("frequency");
title("Periodogram of Ximod");

Xqmod = -2*XQ.*sin(2*pi*F0*tx);

figure();
plot(tx, Xqmod);
xlabel("time");
title("Xqmod");

Fxqmod = fftshift(fft(Xqmod,NFFT)*Ts);
Pxqmod_numerator = abs(Fxqmod).^2;
Pxqmod = Pxqmod_numerator/T_total;

figure();
plot(f,Pxqmod);
xlabel("frequency");
title("Periodogram of Xqmod");

%A6
Xmod = Ximod + Xqmod;

figure();
plot(tx, Xmod);
xlabel("time");
title("Ximod + Xqmod");

Fxmod = fftshift(fft(Xmod,NFFT)*Ts);
Pxmod_numerator = abs(Fxmod).^2;
Pxmod = Pxmod_numerator/T_total;

figure();
plot(f,Pxmod);
xlabel("frequency");
title("Periodogram of Ximod + Xqmod");

%A8
numerator = 10*(A^2);
denominator = Ts*(10^(SNR/10));
var_w = numerator/denominator;

W = sqrt(var_w)*randn(1,length(Xmod));
Xexit = Xmod + W;

figure();
plot(tx, Xmod, 'r');
hold on;
plot(tx, Xexit, 'g');
xlabel("time");
title("Channel exit");
legend("no noise", "with noise");
hold off;

%A9
XIexit = Xexit.*cos(2*pi*F0*tx);

figure();
plot(tx, XIexit);
xlabel("time");
title("Xi exit");

Fxiexit = fftshift(fft(XIexit,NFFT)*Ts);
Pxiexit_numerator = abs(Fxiexit).^2;
Pxiexit = Pxiexit_numerator/T_total;

figure();
plot(f,Pxiexit);
xlabel("frequency");
title("Periodogram Xi exit");

XQexit = -Xexit.*sin(2*pi*F0*tx);

figure();
plot(tx, XQexit);
xlabel("time");
title("Xq exit");

Fxqexit = fftshift(fft(XQexit,NFFT)*Ts);
Pxqexit_numerator = abs(Fxqexit).^2;
Pxqexit = Pxqexit_numerator/T_total;

figure();
plot(f,Pxqexit);
xlabel("frequency");
title("Periodogram Xq exit");

%A10
Iexit = conv(XIexit, phi)*Ts;

txexit = linspace(tx(1)+t(1),tx(end)+t(end),length(Iexit));
T_total_exit = length(txexit)*Ts;

figure();
plot(txexit, Iexit);
xlabel("time");
title("Xi exit after filter");

Fiexit = fftshift(fft(Iexit,NFFT)*Ts);
Pi_numerator = abs(Fiexit).^2;
Pi = Pi_numerator/T_total_exit;

figure();
plot(f,Pi);
xlabel("frequency");
title("Periodogram Xi exit after filter");

Qexit = conv(XQexit, phi)*Ts;

figure();
plot(txexit, Qexit);
xlabel("time");
title("Xq exit after filter");

Fq = fftshift(fft(Qexit,NFFT)*Ts);
Pq_numerator = abs(Fq).^2;
Pq = Pq_numerator/T_total_exit;

figure();
plot(f,Pq);
xlabel("frequency");
title("Periodogram Xq exit after filter");

%A11
Y = zeros(2,N);

j = 1;
for i = 2*A*over:over:length(txexit)-2*A*over-1
    
    Y(1,j) = Iexit(i);
    Y(2,j) = Qexit(i);
    j = j + 1;
    
end

scatterplot(Y');

%A12
est_XI = detect_4_PAM(Y(1,:),A);
est_XQ = detect_4_PAM(Y(2,:),A);

%A13
total_errors = 0;

for i = 1:N

    if(est_XI(i) ~= Xi(i) || est_XQ(i) ~= Xq(i))
        total_errors = total_errors + 1;
    end

end
total_errors

%A14
Xn = [est_XI est_XQ];
est_bit = PAM_4_to_bits(Xn,A);

%A15
bit_errors = 0;
for i = 1:length(b)

    if(est_bit(i) ~= b(i))
        bit_errors = bit_errors + 1;
    end

end
bit_errors

