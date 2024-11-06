clear all
close all

T = 10^(-3);
over = 10;
Ts = T/over;
A = 4;
a = 0.5;
fs = 1/Ts;
NFFT = 2048;
f = -fs/2 : fs/NFFT : fs/2 - fs/NFFT;
N = 100;
K = 500;

[phi,t] = srrc_pulse(T, over, A, a);

PHI = fftshift(fft(phi, NFFT)*Ts);
PHI_abs = abs(PHI);

phi_energy_spec = PHI_abs.^2;
figure();
semilogy(f, phi_energy_spec);


b = (sign(randn(N,1))+1)/2;
Xn = bits_to_2PAM(b);

% Xd = fs*upsample(Xn,over);
% td = linspace(0,N*T,N*over);
% 
X = conv(Xn, phi);
tx = linspace(t(1),N*T+t(end),length(X));
figure();
plot(tx,X);
grid on;

X_var = var(X);

Sx = (X_var/T)*phi_energy_spec;

%%%%%%%%%%%%%%%            A3                %%%%%%%%%%%%%%%%%%%

Fx = fftshift(fft(X,NFFT)*Ts);
Px_numerator = abs(Fx).^2;
T_total = length(tx)*Ts;
Px = Px_numerator/T_total;
figure();
plot(f, Px);

figure();
semilogy(f,Px);

figure();
for i = 1:K
   
    b_tmp = (sign(randn(N,1))+1)/2;
    Xn_tmp = bits_to_2PAM(b_tmp);

%     Xd_tmp = fs*upsample(Xn_tmp,over);
%     td_tmp = linspace(0,N*T,N*over);

    X_tmp = conv(Xn_tmp, phi);
    tx_tmp = linspace(t(1),N*T+t(end),length(X_tmp));
    
    Fx_tmp = fftshift(fft(X_tmp,NFFT)*Ts);
    Px_numerator_tmp = abs(Fx_tmp).^2;
    T_total_tmp = length(tx_tmp)*Ts;
    Px_tmp(i,:) = Px_numerator_tmp/T_total_tmp;
    
    semilogy(f,Px_tmp(i,:),'b');
    hold on;
    
end
hold off;

figure();
semilogy(f,Sx,'r');
hold on;
semilogy(f,mean(Px_tmp),'g');
hold off;















