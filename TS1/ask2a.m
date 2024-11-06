clear all
close all

% Δεδομένα
T = 10^(-3);
over = 10;
Ts = T/over;
A = 4;
a = 0.5;
fs = 1/Ts;
NFFT = 2048;
f = -fs/2 : fs/NFFT : fs/2 - fs/NFFT;
N = 100; % 200, 1000
K = 500; % 1000, 1500
T2 = 2*T;
over2 = 2*over;
Ts2 = T2/over2;
fs2 = 1/Ts2;

%%%%%%%%%%%%%%%             A1                %%%%%%%%%%%%%%%%%%%

% Κατασκευάζουμε ένα SRRC παλμό και σχεδιάζουμε τη φασματική
% πυκνότητα ισχύος
[phi,t] = srrc_pulse(T, over, A, a);

PHI = fftshift(fft(phi, NFFT)*Ts);
PHI_abs = abs(PHI);

phi_energy_spec = PHI_abs.^2;
figure();
semilogy(f, phi_energy_spec);
title("Energy spectrum of SRRC pulse");
xlabel("Frequency(Hz)");
ylabel("Energy spectrum");

%%%%%%%%%%%%%%%             A2                %%%%%%%%%%%%%%%%%%%

b = (sign(randn(N,1))+1)/2;
Xn = bits_to_2PAM(b);

% φτιάχνω το Χδ και κανω συνέλιξη με το φ έτσι θα δημιουργήσω το σήμα Χ
% όπως έγινε στην άσκηση 1 
% αποδεικνύεται στην αναφορά αυτή ότι αυτή η σχέση ισχύει
Xd = fs*upsample(Xn,over);
td = linspace(0,N*T,N*over);

X = conv(Xd, phi)*Ts;
tx = linspace(td(1)+t(1),td(end)+t(end),length(X));
figure();
plot(tx,X);
grid on;
ylabel("X(t)");
xlabel("time(sec)");

% βρίσκω την συνδιασπορά και έπειτα 
% τη θεωρητική φασματική πυκνότητα ισχύος
X_var = var(X);
Sx = (X_var/T)*phi_energy_spec;

%%%%%%%%%%%%%%%             A3                %%%%%%%%%%%%%%%%%%%

% σύμφωνα με τον τύπο της άσκησης υπολογίζονται τα περιοδογράμματα
% και τυπώνονται σε plot και semilogy
Fx = fftshift(fft(X,NFFT)*Ts);
Px_numerator = abs(Fx).^2;
T_total = length(tx)*Ts;
Px = Px_numerator/T_total;
figure();
plot(f, Px);
title("Periodogram (plot)");
xlabel("Frequency(Hz)");
ylabel("Px(F)");

figure();
semilogy(f,Px);
title("Periodogram (semilogy)");
xlabel("Frequency(Hz)");
ylabel("Px(F)");

% με αυτή την επανάληψη βλέπω την μορφή των περιοδογραμμάτων
% for j=1:9
%     
%     b_per = (sign(randn(N,1))+1)/2;
%     Xn_per = bits_to_2PAM(b_per);
% 
%     Xd_per = fs*upsample(Xn_per,over);
%     td_per = linspace(0,N*T,N*over);
% 
%     X_per = conv(Xd_per, phi)*Ts;
%     tx_per = linspace(td_per(1)+t(1),td_per(end)+t(end),length(X_per));
% 
%     Fx_per = fftshift(fft(X_per,NFFT)*Ts);
%     Px_numerator_per = abs(Fx_per).^2;
%     T_total_per = length(tx_per)*Ts;
%     Px_per = Px_numerator_per/T_total_per;
%     figure();
%     plot(f, Px_per);
%     title("Periodogram (plot)");
%     xlabel("Frequency(Hz)");
%     ylabel("Px(F)");
% 
%     figure();
%     semilogy(f,Px_per);
%     title("Periodogram (semilogy)");
%     xlabel("Frequency(Hz)");
%     ylabel("Px(F)");
%     
% end

% υπολογίζω 500 περιοδογράμματα σε κοινό semilogy
figure();
for i = 1:K
   
    b_tmp = (sign(randn(N,1))+1)/2;
    Xn_tmp = bits_to_2PAM(b_tmp);

    Xd_tmp = fs*upsample(Xn_tmp,over);
    td_tmp = linspace(0,N*T,N*over);

    X_tmp = conv(Xd_tmp, phi)*Ts;
    tx_tmp = linspace(td_tmp(1)+t(1),td_tmp(end)+t(end),length(X_tmp));
    
    Fx_tmp = fftshift(fft(X_tmp,NFFT)*Ts);
    Px_numerator_tmp = abs(Fx_tmp).^2;
    T_total_tmp = length(tx_tmp)*Ts;
    Px_tmp(i,:) = Px_numerator_tmp/T_total_tmp;
    
    semilogy(f,Px_tmp(i,:),'b');
    hold on;
    
end
title("Periodogram of 500 different X(t)");
xlabel("Frequency(Hz)");
ylabel("Px(F)");
hold off;

% τυπώνω την θεωρητική και την πειραματική/μέση τιμή της
% φασματικής πυκνότητας ισχύος
figure();
semilogy(f,Sx,'r');
hold on;
semilogy(f,mean(Px_tmp),'g');
title("Theoretical vs Experimental power spectrum");
xlabel("Frequency(Hz)");
ylabel("Sx(F)");
legend("Theoretical", "Experimental");
hold off;

%%%%%%%%%%%%%%%             A4                %%%%%%%%%%%%%%%%%%%

% με την ίδια αλληλουχία bits αλλά διαφορετική συνάρτηση
% υπολογίζουμε τα ίδια με τα δύο προηγούμενα ερωτήματα
Xn2 = bits_to_4PAM(b);

Xd2 = fs*upsample(Xn2,over);
td2 = linspace(0,(N/2)*T,(N/2)*over);

X2 = conv(Xd2, phi)*Ts;
tx2 = linspace(td2(1)+t(1),td2(end)+t(end),length(X2));
figure();
plot(tx2,X2);
grid on;
ylabel("X(t)");
xlabel("time(sec)");

X_var2 = var(X2);

Sx2 = (X_var2/T)*phi_energy_spec;

figure();
for i = 1:K
   
    b_tmp = (sign(randn(N,1))+1)/2;
    Xn_tmp = bits_to_4PAM(b_tmp);

    Xd_tmp = fs*upsample(Xn_tmp,over);
    td_tmp = linspace(0,(N/2)*T,(N/2)*over);

    X_tmp = conv(Xd_tmp, phi)*Ts;
    tx_tmp = linspace(td_tmp(1)+t(1),td_tmp(end)+t(end),length(X_tmp));
    
    Fx_tmp = fftshift(fft(X_tmp,NFFT)*Ts);
    Px_numerator_tmp = abs(Fx_tmp).^2;
    T_total_tmp = length(tx_tmp)*Ts;
    Px_tmp(i,:) = Px_numerator_tmp/T_total_tmp;
    
    semilogy(f,Px_tmp(i,:),'b');
    hold on;
    
end
title("Periodogram of 500 different X(t)");
xlabel("Frequency(Hz)");
ylabel("Px(F)");
hold off;

figure();
semilogy(f,Sx2,'r');
hold on;
semilogy(f,mean(Px_tmp),'g');
title("Theoretical vs Experimental power spectrum");
xlabel("Frequency(Hz)");
ylabel("Sx(F)");
legend("Theoretical", "Experimental");
hold off;

% συγκρίνω τις θεωρητικές φασματικές πυκνότητες ισχύος
% της ίδιας αλληλουχίας bits με διαφορετική απεικόνιση
figure();
semilogy(f,Sx,'r');
hold on;
semilogy(f,Sx2,'g');
title("2PAM vs 4PAM power spectrum");
xlabel("Frequency(Hz)");
ylabel("Sx(F)");
legend("2PAM", "4PAM");
hold off;

%%%%%%%%%%%%%%%              A5                %%%%%%%%%%%%%%%%%%%

% αλλάζω την περίοδο άρα πρέπει να φτιάξω και νέο παλμό SRRC
% επαναλαμβάνω τα ερωτήματα 2 και 3
[phi2,t2] = srrc_pulse(T2, over2, A, a);

PHI2 = fftshift(fft(phi2, NFFT)*Ts2);
PHI_abs2 = abs(PHI2);

phi_energy_spec2 = (PHI_abs2).^2;

Xk = bits_to_2PAM(b);

Xdelta = fs2*upsample(Xk,over2);
tdelta = linspace(0,N*T2,N*over2);

X_3 = conv(Xdelta, phi2)*Ts2;
tx_3 = linspace(tdelta(1)+t2(1),tdelta(end)+t2(end),length(X_3));
figure();
plot(tx_3,X_3);
grid on;
ylabel("X(t)");
xlabel("time(sec)");

X_var3 = var(X_3);

Sx3 = (X_var3/T2)*phi_energy_spec2;

Fx3 = fftshift(fft(X_3,NFFT)*Ts2);
Px_numerator3 = abs(Fx3).^2;
T_total3 = length(tx_3)*Ts2;
Px3 = Px_numerator3/T_total3;

figure();
plot(f, Px3);
title("Periodogram (plot)");
xlabel("Frequency(Hz)");
ylabel("Px(F)");

figure();
semilogy(f,Px3);
title("Periodogram (semilogy)");
xlabel("Frequency(Hz)");
ylabel("Px(F)");


figure();
for i = 1:K
   
    b_tmp = (sign(randn(N,1))+1)/2;
    Xn_tmp = bits_to_2PAM(b_tmp);

    Xd_tmp = fs2*upsample(Xn_tmp,over2);
    td_tmp = linspace(0,N*T2,N*over2);

    X_tmp = conv(Xd_tmp, phi2)*Ts2;
    tx_tmp = linspace(td_tmp(1)+t2(1),td_tmp(end)+t2(end),length(X_tmp));
    
    Fx_tmp = fftshift(fft(X_tmp,NFFT)*Ts2);
    Px_numerator_tmp = abs(Fx_tmp).^2;
    T_total_tmp = length(tx_tmp)*Ts2;
    Px_tmp(i,:) = Px_numerator_tmp/T_total_tmp;
    
    semilogy(f,Px_tmp(i,:),'b');
    hold on;
    
end
title("Periodogram of 500 different X(t)");
xlabel("Frequency(Hz)");
ylabel("Px(F)");
hold off;

figure();
semilogy(f,Sx3,'r');
hold on;
semilogy(f,mean(Px_tmp),'g');
title("Theoretical vs Experimental power spectrum");
xlabel("Frequency(Hz)");
ylabel("Sx(F)");
legend("Theoretical", "Experimental");
hold off;

% συγκρίνω τις κυματομορφές της Χ για τις δύο περιόδους
figure();
plot(tx,X,'r');
hold on;
grid on;
plot(tx_3,X_3,'g');
title("A.3 vs A.5 X(t)");
xlabel("time(sec)");
ylabel("X(t)");
legend("A.3", "A.5");
hold off;

% συγκρίνω τα εύρη φάσματος για τις δύο περιόδους
figure();
semilogy(f,Sx,'r');
hold on;
semilogy(f,Sx3,'g');
title("A.3 vs A.5 power spectrum");
xlabel("Frequency(Hz)");
ylabel("Sx(F)");
legend("A.3", "A.5");
hold off;
