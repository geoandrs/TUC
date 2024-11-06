clear all
close all

T = 10; % 10
over = 10;
Ts = T/over;
A = 4;
a = 0.5;
fs = 1/Ts;
NFFT = 2048;
f0 = 1/3; % 1/3 % 1/2T = 0.5 και Fs/2-1/2T = 4.5  0.5<3<4.5
fb = fs/NFFT;
f = -fs/2 : fb : fs/2 - fs/NFFT;
N = 100;
K = 1000;


[phi,t] = srrc_pulse(T, over, A, a);
PHI = fftshift(fft(phi, NFFT)*Ts);
PHI_abs = abs(PHI);
phi_energy_spec = PHI_abs.^2;

b = (sign(randn(N,1))+1)/2;
Xn = bits_to_2PAM(b);
Xd = fs*upsample(Xn,over);
td = linspace(0,N*T,N*over);
X = conv(Xd, phi)*Ts;
tx = linspace(td(1)+t(1),td(end)+t(end),length(X));

X_var = var(X);
Sx = (X_var/T)*phi_energy_spec;

fn = -fs/2 - f0 : fb : fs/2 -fs/NFFT;
index = length(fn)-length(f);

Sx_n = [zeros(1, index) Sx(1:end-index)];
Sx_p = [Sx(index+1:end) zeros(1, index)];

Sy_theory = 1/4*(Sx_n + Sx_p);

for i = 1:K
   
    b_tmp = (sign(randn(N,1))+1)/2;
    Xn_tmp = bits_to_2PAM(b_tmp);

    Xd_tmp = fs*upsample(Xn_tmp,over);
    td_tmp = linspace(0,N*T,N*over);

    X_tmp = conv(Xd_tmp, phi)*Ts;
    tx_tmp = linspace(td_tmp(1)+t(1),td_tmp(end)+t(end),length(X_tmp));
    
    c_tmp = cos(2*pi*f0*tx);
    Y_tmp = X_tmp.*c_tmp;
    
    Fy_tmp = fftshift(fft(Y_tmp,NFFT)*Ts);
    Py_numerator_tmp = abs(Fy_tmp).^2;
    T_total_tmp = length(tx_tmp)*Ts;
    Py_tmp(i,:) = Py_numerator_tmp/T_total_tmp;
     
end

figure();
semilogy(f,mean(Py_tmp));
hold on;
semilogy(f,Sy_theory, "r");
title("Theoretical vs Experimental power spectrum");
xlabel("Frequency(Hz)");
ylabel("Sy(F)");
legend("Experimental", "Theoretical");
hold off;

