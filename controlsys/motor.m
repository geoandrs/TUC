clear 
close all

s = zpk('s');

%% Q1

% calculated from lab 
Ks = 0.8;
Tg = 1.05;
Tu = 0.14;

% calculate T1 and T2 with theoretical types
T1 = Tg/exp(1);
T2 = Tu/(3-exp(1));

% transfer function
H = Ks/(T1*s+1)/(T2*s+1);

% calculate parameters for PI controller with CHR overshoot 0%
Kchr = (0.35*Tg)/(Ks*Tu);
Ti_chr = 1.2*Tg;

%% Q2

% calculate the tf for the whole system
P = pidstd(Kchr,Ti_chr);
F = feedback(P*H,1);

t = 0:0.01:60; % time for experiment
T = 15; % period of pulse
phase = 2*pi*t/T; % phase of pulse for time t

pulse = sin(phase) >= 0; % square pulse
spulse = 500*pulse+1500; % lift pulse to match with the experiment

figure() % plot step response with CHR method
lsim(F, spulse, t)

Y = lsim(F, spulse, t).'; % tf values at time t
e = spulse-Y; % find error between pulse and tf
ISE_CHR = trapz(t, e.^2) % calculate and print ISE
ITSE_CHR = trapz(t, t.*(e.^2)) % calculate and print ITSE

%% Q3

% calculate Tsum method parameters
K_Tsum = 0.5/Ks;
TiTsum = 0.5*(T1+T2);

% calculate the tf for the whole system
P = pidstd(K_Tsum,TiTsum);
F = feedback(P*H,1);

figure() % plot step response with CHR method
lsim(F, spulse, t)

Y = lsim(F, spulse, t).'; % tf values at time t
e = spulse-Y; % find error between pulse and tf
ISE_Tsum = trapz(t, e.^2) % calculate and print ISE
ITSE_Tsum = trapz(t, t.*(e.^2)) % calculate and print ITSE

%% Q4

% calculated from lab 
Ks = 0.87;
Tu = 0.1;
Tg = 1.12;

% calculate T1 and T2 with theoretical types
T1 = Tg/exp(1);
T2 = Tu/(3-exp(1));

% transfer function
H = Ks/(T1*s+1)/(T2*s+1);

% calculate parameters for PI controller with CHR overshoot 0%
Kchr = (0.35*Tg)/(Ks*Tu);
Ti_chr = 1.2*Tg;

%% Q5

% calculate the tf for the whole system
P = pidstd(Kchr,Ti_chr);
F = feedback(P*H,1);

t = 0:0.01:60; % time for experiment
T = 15; % period of pulse
phase = 2*pi*t/T; % phase of pulse for time t

pulse = sin(phase) >= 0; % square pulse
spulse = 2.1*pulse+3; % lift pulse to match with the experiment

figure() % plot step response with CHR method
lsim(F, spulse, t)

Y = lsim(F, spulse, t).'; % tf values at time t
e = spulse-Y; % find error between pulse and tf
ISE_CHR2 = trapz(t, e.^2) % calculate and print ISE
ITSE_CHR2 = trapz(t, t.*(e.^2)) % calculate and print ITSE

%% Q6

% calculate Tsum method parameters
K_Tsum = 0.5/Ks;
TiTsum = 0.5*(T1+T2);

% calculate the tf for the whole system
P = pidstd(K_Tsum,TiTsum);
F = feedback(P*H,1);

figure() % plot step response with CHR method
lsim(F, spulse, t)

Y = lsim(F, spulse, t).'; % tf values at time t
e = spulse-Y; % find error between pulse and tf
ISE_Tsum2 = trapz(t, e.^2) % calculate and print ISE
ITSE_Tsum2 = trapz(t, t.*(e.^2)) % calculate and print ITSE