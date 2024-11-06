clear all
close all

L = 4;
N = 128;

h = sqrt(1/(2*L))*(randn(1,L) + 1i*randn(1,L));
d_tilda = bits_to_4QAM(N);
        
d = sqrt(N)*ifft(d_tilda);
x = [d(N-L+2:N),d];
y = conv(h,x);
ym = y(L:N+L-1);
y_tilda = (1/sqrt(N))*fft(ym);


h_tilda = (1/sqrt(N))*fft(h,N);
y_tilda_flat = sqrt(N)*h_tilda.*d_tilda;

norm(y_tilda-y_tilda_flat)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SNR = 22;

h = sqrt(1/(2*L))*(randn(1,L) + 1i*randn(1,L));
d_tilda = bits_to_4QAM(N);
        
d = sqrt(N)*ifft(d_tilda);

No = 2/db2mag(SNR);
wf = (No/2)*(randn(1,N) + 1i*randn(1,N));

x = [d(N-L+2:N),d];
y = conv(h,x);
ym = y(L:N+L-1) + wf;
y_tilda = (1/sqrt(N))*fft(ym);
h_tilda = (1/sqrt(N))*fft(h,N);

err = zeros(1,N);
for k = 1:N
    err(k) = find_errors(d_tilda(k), conj(h_tilda(k))*y_tilda(k));
end
        
figure();
subplot(211);
semilogy(0:1/N:1-1/N, abs(h_tilda));
grid on;
subplot(212);
stem(0:1/N:1-1/N, err, 'r')
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = 100000;

SNRdB = 0:2:30;

[f1,f2,f3,f4] = SNR_functions(SNRdB);

[OFDM_err_diversity1] = BER_OFDM_Diversity(K,N,L,1,SNRdB);

[OFDM_err_diversity2] = BER_OFDM_Diversity(K,N,L,2,SNRdB);

[OFDM_err_diversity4] = BER_OFDM_Diversity(K,N,L,4,SNRdB);

figure();
semilogy(SNRdB, OFDM_err_diversity1)
hold on;
semilogy(SNRdB, f1, 'r')
semilogy(SNRdB, f2, 'g')
semilogy(SNRdB, f3, 'y')
semilogy(SNRdB, f4, 'm')
xlabel("SNR (dB)")
ylabel("BER")
legend("OFDM Diversity = 1","1/SNR","1/SNR^2","1/SNR^3","1/SNR^4")
legend("Location","southwest")
grid on;
hold off;

figure();
semilogy(SNRdB, OFDM_err_diversity2)
hold on;
semilogy(SNRdB, f1, 'r')
semilogy(SNRdB, f2, 'g')
semilogy(SNRdB, f3, 'y')
semilogy(SNRdB, f4, 'm')
xlabel("SNR (dB)")
ylabel("BER")
legend("OFDM Diversity = 2","1/SNR","1/SNR^2","1/SNR^3","1/SNR^4")
legend("Location","southwest")
grid on;
hold off;

figure();
semilogy(SNRdB, OFDM_err_diversity4)
hold on;
semilogy(SNRdB, f1, 'r')
semilogy(SNRdB, f2, 'g')
semilogy(SNRdB, f3, 'y')
semilogy(SNRdB, f4, 'm')
xlabel("SNR (dB)")
ylabel("BER")
legend("OFDM Diversity = 4","1/SNR","1/SNR^2","1/SNR^3","1/SNR^4")
legend("Location","southwest")
grid on;
hold off;