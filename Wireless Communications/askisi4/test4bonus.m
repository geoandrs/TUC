clear
close all

K = 6; % channel order
K_est = K+3; % estimated channel order for underestimation
N = 400; % symbols
n1 = 140; % position of the first training symbol
n2 = 220; % position of the last training symbol
SNRdB = 15; 
Delta = 2*K_est; % delay for the equalizers
order = 4*K_est; % equalizers order

hk = (randn(1,K+1) + 1i*randn(1,K+1)); % random complex channel
h = (1/norm(hk))*hk; % normalization 

s = bits_to_4QAM(N); % 4-QAM symbol sequence
ntrain = s(n1:n2); % training symbols

y = conv(s,h); % channel output without noise

varw = 1/db2mag(SNRdB); % noise variance
w = (varw/2)*(randn(1,N+K) + 1i*randn(1,N+K)); % AWGN noise

yw = y + w; % channel output with noise

hls = Estimate_Channel(s,n1,n2,K_est,yw);

fZF = ZF_Equalizer(hls,order,K_est,Delta); % ZF Equalizer
hsyn = conv(h,fZF); % composite impulse response of channel
                    % with noise and ZF Equalizer
                          
figure(); % plot real and imaginary part of CIR
subplot(211)
stem(1:length(hsyn),real(hsyn))
title("Real part of Composite Impulse Response")
subplot(212)
stem(1:length(hsyn),imag(hsyn),'r')
title("Imaginary part of Composite Impulse Response")
grid on;
                      
yf = conv(yw,fZF); % equalizer output with noise channel output as input
sin = yf(Delta:N+Delta-1); % an estimation of the input 

scatterplot(sin) % plot the estimated output

fls = LS_Equalizer(yw,n1,n2,Delta,order,ntrain); % Least Squares Equalizer

hsynls = conv(h,fls); % composite impulse response of channel
                      % with noise and LS Equalizer
                            
figure(); % plot real and imaginary part of CIR
subplot(211)
stem(1:length(hsynls),real(hsynls))
title("Real part of Composite Impulse Response")
subplot(212)
stem(1:length(hsynls),imag(hsynls),'r')
title("Imaginary part of Composite Impulse Response")
grid on;
                        
yfls = conv(yw,fls); % equalizer output with noise channel output as input
sinls = yfls(Delta:N+Delta-1); % an estimation of the input

scatterplot(sinls) % plot the estimated output