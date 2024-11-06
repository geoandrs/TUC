clear all
close all

% ερώτημα 1
% create a complex flat fading channel
% using AR-1

N = 200; % another value N = 200
b = 0.05;
t = 1:N;

h = flat_fading_channel(N, b);

figure();
subplot(2, 1, 1)
plot(t, real(h))
title("Real part of flat fading channel b<<1")
xlabel("Time")
ylabel("Real(h)")
grid on;
subplot(2, 1, 2)
plot(t, imag(h))
title("Imaginary part of flat fading channel b<<1")
xlabel("Time")
ylabel("Imag(h)")
grid on;

% χρειάζεται να προσθέσουμε 100 στοιχεία
% και να πάρουμε τις τελευταίες Ν τιμές
N2 = N+100;
b2 = 0.99;

h2_tmp = flat_fading_channel(N2, b2);
h2 = h2_tmp(101:N2);

figure();
subplot(2, 1, 1)
plot(t, real(h2))
title("Real part of flat fading channel b~=1")
xlabel("Time")
ylabel("Real(h)")
grid on;
subplot(2, 1, 2)
plot(t, imag(h2))
title("Imaginary part of flat fading channel b~=1")
xlabel("Time")
ylabel("Imag(h)")
grid on;

% ερώτημα 2
% create 4-QAM input
s = bits_to_4QAM(N);

% ερώτημα 3
% calculate output of flat fading
% channel with 4-QAM input
No = 1/2;
SNR_dB = 10*log10(2/No);
w = sqrt(No/2)*(randn(N, 1) + 1i*randn(N, 1));

r = zeros(1, N);
for k = (1:N)
    r(k) = h(k)*s(k) + w(k);
end

% ερώτημα 4, 5, 6
detected_input = detect_4QAM_atFFC(N, h, r);

[real_errors, imag_errors, bit_errors] = find_errors(N, s, detected_input);
 
figure();
subplot(2, 1, 1)
semilogy(t, abs(real(h)))
title("Amplitude of real part of channel b<<1")
xlabel("Time")
ylabel("|Real(h)|")
grid on;
subplot(2, 1, 2)
stem(t, real_errors)
title("Errors at real part")
xlabel("Time")
ylabel("Errors")
grid on;
 
figure();
subplot(2, 1, 1)
semilogy(t, abs(imag(h)))
title("Amplitude of imaginary part of channel b<<1")
xlabel("Time")
ylabel("|Imag(h)|")
grid on;
subplot(2, 1, 2)
stem(t, imag_errors)
title("Errors at imaginary part")
xlabel("Time")
ylabel("Errors")
grid on;

r2 = zeros(1, N);
for k = (1:N)
    r2(k) = h2(k)*s(k) + w(k);
end


detected_input2 = detect_4QAM_atFFC(N, h2, r2);
 
[r_err, im_err, b_err] = find_errors(N, s, detected_input2);
 
figure();
subplot(2, 1, 1)
semilogy(t, abs(real(h2)))
title("Amplitude of real part of channel b~=1")
xlabel("Time")
ylabel("|Real(h)|")
grid on;
subplot(2, 1, 2)
stem(t, r_err)
title("Errors at real part")
xlabel("Time")
ylabel("Errors")
grid on;
 
figure();
subplot(2, 1, 1)
semilogy(t, abs(imag(h2)))
title("Amplitude of imaginary part of channel b~=1")
xlabel("Time")
ylabel("|Imag(h)|")
grid on;
subplot(2, 1, 2)
stem(t, im_err)
title("Errors at imaginary part")
xlabel("Time")
ylabel("Errors")
grid on;

% ερώτημα 7
SNRdB = 0:2:30;
SNR = db2mag(2*SNRdB);

K = 5000;

BER_approx = zeros(1, length(SNR));
BER_approx2 = zeros(1, length(SNR));
for k = 1:length(SNR)
    BER_approx(k) = (1/2)*(1-sqrt(SNR(k)/(2+SNR(k))));
    BER_approx2(k) = 1/(2*SNR(k));
end

total_BER = zeros(1, length(SNRdB));
v = 1;
for tmpSNRdB = 0:2:30
    
    for k = 1:K
        
        h = flat_fading_channel(N, b);

        s = bits_to_4QAM(N);
        No = 2/db2mag(2*tmpSNRdB);
        w = sqrt(No)*(randn(N, 1) + 1i*randn(N, 1));

        r = zeros(1, N);
        for m = (1:N)
            r(m) = h(m)*s(m) + w(m);
        end
        
        di = detect_4QAM_atFFC(N, h, r);

        [real_errors, imag_errors, bit_errors] = find_errors(N, s, di);
        total_BER(v) = total_BER(v) + bit_errors;
    end
    v = v+1;
    
end
total_BER = total_BER/(2*N*K);
        

figure();
semilogy(SNRdB, BER_approx)
hold on;
semilogy(SNRdB, BER_approx2, 'r')
semilogy(SNRdB, total_BER, 'g')
xlabel("SNR (dB)")
ylabel("BER")
legend("BER approximation", "BER approximation high SNR", "Experimental BER")
grid on;
hold off;

% ερώτημα 8
AWGN_BER = zeros(1, length(SNRdB));
v = 1;
for tmpSNRdB = 0:2:30
    
    for k = 1:K

        s = bits_to_4QAM(N);
        No = 2/db2mag(2*tmpSNRdB);
        w = sqrt(No/2)*(randn(N, 1) + 1i*randn(N, 1));

        y = zeros(1, N);
        for m = (1:N)
            y(m) = s(m)+w(m);
        end
        
        di = detect_4QAM(N, y);

        [real_errors, imag_errors, bit_errors] = find_errors(N, s, di);
        AWGN_BER(v) = AWGN_BER(v) + bit_errors;
    end
    v = v+1;
    
end
AWGN_BER = AWGN_BER/(2*N*K);

figure();
semilogy(SNRdB, AWGN_BER)
hold on;
semilogy(SNRdB, total_BER, 'r')
xlabel("SNR (dB)")
ylabel("BER")
legend("BER AWGN", "Experimental BER")
grid on;
hold off;

% ερώτημα 9
K = 10000;
N = 100;
SNRdB = 0:2:30;

total_BER_bffc = zeros(1, length(SNRdB));
v = 1;
for tmpSNRdB = 0:2:30
    
    h = (randn(K, 1) + 1i*randn(K, 1));
    for k = 1:K
        
        s = bits_to_4QAM(N);
        No = 2/db2mag(2*tmpSNRdB);
        w = sqrt(No)*(randn(N, 1) + 1i*randn(N, 1));

        r = zeros(1, N);
        for m = (1:N)
            r(m) = h(k)*s(m) + w(m);
        end
        
        di = detect_4QAM_atBFFC(N, h(k), r);

        [real_errors, imag_errors, bit_errors] = find_errors(N, s, di);
        total_BER_bffc(v) = total_BER_bffc(v) + bit_errors;
        
    end
    v = v + 1;
end
total_BER_bffc = total_BER_bffc/(2*N*K);

figure();
semilogy(SNRdB, total_BER_bffc)
hold on;
semilogy(SNRdB, total_BER, 'r')
xlabel("SNR (dB)")
ylabel("BER")
legend("flat fading BER", "block flat fading BER")
grid on;
hold off;