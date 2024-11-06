clear
close all

s = zpk('s');

%% Q1

% calculated from lab
Ks = 0.75;
Tg = 50;
Tu = 5;

% calculate T1 and T2 with theoretical types
T1 = Tg/exp(1);
T2 = Tu/(3-exp(1));
Tsys_theory = T1+T2;

H1 = Ks/(T1*s+1)/(T2*s+1); % transfer function for theoretical T1,T2

t = 0:0.1:200; % time for our system
in = 3*(t>0); % input signal

figure()
lsim(H1,in,t)

% T1 and T2 given 
T1 = 10;
T2 = 40;
Tsys_given = T1+T2;

H2 = Ks/(T1*s+1)/(T2*s+1); % transfer function for given T1,T2

figure()
lsim(H2,in,t)

%% Q2

% P controller CHR 20% Overshoot setpoint response
Kp = 0.7*Tg/Ks/Tu;

P = pidstd(Kp);
FP1 = feedback(P*H1,1);
FP2 = feedback(P*H2,1);
t = 0:0.1:300;
in = 6*(t>=0 & t<=150) + 5*(t>150);

figure()
lsim(FP1,in,t)
Y1 = lsim(FP1,in,t).'; % tf values at time t
e = in-Y1; % find error between pulse and tf
ISE_P1 = trapz(t,e.^2) % calculate and print ISE
ITSE_P1 = trapz(t,t.*(e.^2)) % calculate and print ITSE

figure()
lsim(FP2,in,t)
Y2 = lsim(FP2,in,t).'; % tf values at time t
e = in-Y2; % find error between pulse and tf
ISE_P2 = trapz(t,e.^2) % calculate and print ISE
ITSE_P2 = trapz(t,t.*(e.^2)) % calculate and print ITSE

% PI controller CHR 20% Overshoot setpoint response
Kpi = 0.6*Tg/Ks/Tu;
TiPI = Tg;

PI = pidstd(Kpi,TiPI);
FPI1 = feedback(PI*H1,1);
FPI2 = feedback(PI*H2,1);
t = 0:0.1:300;
in = 6*(t>=0 & t<=150) + 5*(t>150);

figure()
lsim(FPI1,in,t)
Y1 = lsim(FPI1,in,t).'; % tf values at time t
e = in-Y1; % find error between pulse and tf
ISE_PI1 = trapz(t,e.^2) % calculate and print ISE
ITSE_PI1 = trapz(t,t.*(e.^2)) % calculate and print ITSE

figure()
lsim(FPI2,in,t)
Y2 = lsim(FPI2,in,t).'; % tf values at time t
e = in-Y2; % find error between pulse and tf
ISE_PI2 = trapz(t,e.^2) % calculate and print ISE
ITSE_PI2 = trapz(t,t.*(e.^2)) % calculate and print ITSE

% PID controller CHR 20% Overshoot setpoint response 
Kpid = 0.95*Tg/Ks/Tu;
TiPID = 1.4*Tg;
TdPID = 0.47*Tu;

PID = pidstd(Kpid,TiPID,TdPID);
FPID1 = feedback(PID*H1,1);
FPID2 = feedback(PID*H2,1);
t = 0:0.1:300;
in = 6*(t>=0 & t<=150) + 5*(t>150);

figure()
lsim(FPID1,in,t)
Y1 = lsim(FPID1,in,t).'; % tf values at time t
e = in-Y1; % find error between pulse and tf
ISE_PID1 = trapz(t,e.^2) % calculate and print ISE
ITSE_PID1 = trapz(t,t.*(e.^2)) % calculate and print ITSE

figure()
lsim(FPID2,in,t)
Y2 = lsim(FPID2,in,t).'; % tf values at time t
e = in-Y2; % find error between pulse and tf
ISE_PID2 = trapz(t,e.^2) % calculate and print ISE
ITSE_PID2 = trapz(t,t.*(e.^2)) % calculate and print ITSE

%% Q3

% PID controller CHR 0% Overshoot load disturbance response
Kpid = 0.95*Tg/Ks/Tu;
TiPID = 2.4*Tg;
TdPID = 0.42*Tu;

PID = pidstd(Kpid,TiPID,TdPID);
FPID1 = feedback(PID*H1,1);
FPID2 = feedback(PID*H2,1);

t = 0:0.1:900;
in = 6*(t>=0 & t<300) + 8*(t>=300 & t<600) + 5*(t>=600);

figure()
lsim(FPID1,in,t)
Y1 = lsim(FPID1,in,t).'; % tf values at time t
e = in-Y1; % find error between pulse and tf
ISE_PID1 = trapz(t,e.^2) % calculate and print ISE
ITSE_PID1 = trapz(t,t.*(e.^2)) % calculate and print ITSE

figure()
lsim(FPID2,in,t)
Y2 = lsim(FPID2,in,t).'; % tf values at time t
e = in-Y2; % find error between pulse and tf
ISE_PID2 = trapz(t,e.^2) % calculate and print ISE
ITSE_PID2 = trapz(t,t.*(e.^2)) % calculate and print ITSE

%% Q4

% P controller Tsum
Kp = 1/Ks;

P = pidstd(Kp);
FP1 = feedback(P*H1,1);
FP2 = feedback(P*H2,1);
t = 0:0.1:300;
in = 6*(t>=0 & t<=150) + 5*(t>150);

figure()
lsim(FP1,in,t)
Y1 = lsim(FP1,in,t).'; % tf values at time t
e = in-Y1; % find error between pulse and tf
ISE_P1 = trapz(t,e.^2) % calculate and print ISE
ITSE_P1 = trapz(t,t.*(e.^2)) % calculate and print ITSE

figure()
lsim(FP2,in,t)
Y2 = lsim(FP2,in,t).'; % tf values at time t
e = in-Y2; % find error between pulse and tf
ISE_P2 = trapz(t,e.^2) % calculate and print ISE
ITSE_P2 = trapz(t,t.*(e.^2)) % calculate and print ITSE

% PI controller Tsum
Kpi = 0.5/Ks;
TiPI1 = 0.5*Tsys_theory;
TiPI2 = 0.5*Tsys_given;

PI1 = pidstd(Kpi,TiPI1);
PI2 = pidstd(Kpi,TiPI2);
FPI1 = feedback(PI1*H1,1);
FPI2 = feedback(PI2*H2,1);
t = 0:0.1:300;
in = 6*(t>=0 & t<=150) + 5*(t>150);

figure()
lsim(FPI1,in,t)
Y1 = lsim(FPI1,in,t).'; % tf values at time t
e = in-Y1; % find error between pulse and tf
ISE_PI1 = trapz(t,e.^2) % calculate and print ISE
ITSE_PI1 = trapz(t,t.*(e.^2)) % calculate and print ITSE

figure()
lsim(FPI2,in,t)
Y2 = lsim(FPI2,in,t).'; % tf values at time t
e = in-Y2; % find error between pulse and tf
ISE_PI2 = trapz(t,e.^2) % calculate and print ISE
ITSE_PI2 = trapz(t,t.*(e.^2)) % calculate and print ITSE

% PID controller Tsum
Kpid = 1/Ks;
TiPID1 = 0.66*Tsys_theory;
TiPID2 = 0.66*Tsys_given;
TdPID1 = 0.17*Tsys_theory;
TdPID2 = 0.17*Tsys_given;

PID1 = pidstd(Kpid,TiPID1,TdPID1);
PID2 = pidstd(Kpid,TiPID2,TdPID2);
FPID1 = feedback(PID1*H1,1);
FPID2 = feedback(PID2*H2,1);
t = 0:0.1:300;
in = 6*(t>=0 & t<=150) + 5*(t>150);

figure()
lsim(FPID1,in,t)
Y1 = lsim(FPID1,in,t).'; % tf values at time t
e = in-Y1; % find error between pulse and tf
ISE_PID1 = trapz(t,e.^2) % calculate and print ISE
ITSE_PID1 = trapz(t,t.*(e.^2)) % calculate and print ITSE

figure()
lsim(FPID2,in,t)
Y2 = lsim(FPID2,in,t).'; % tf values at time t
e = in-Y2; % find error between pulse and tf
ISE_PID2 = trapz(t,e.^2) % calculate and print ISE
ITSE_PID2 = trapz(t,t.*(e.^2)) % calculate and print ITSE
