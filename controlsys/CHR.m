clear 
close all

s = tf('s');

Ks = 1; T1 = 2; T2 = 2; T3 = 2;
H = Ks/((T1*s+1)*(T2*s+1)*(T3*s+1));
[y,t] = step(H);
h = mean(diff(t));
dy = gradient(y, h); % Numerical Derivative
[~,idx] = max(dy); % Index Of Maximum         
% Regression Line Around Maximum Derivative
b = [t([idx-1,idx+1]) ones(2,1)] \ y([idx-1,idx+1]);  
% Independent Variable Range For Tangent Line Plot
tv = [-b(2)/b(1); (1-b(2))/b(1)];                         
% Calculate Tangent Line
f = [tv ones(2,1)] * b;                                   
figure
plot(t, y)
hold on
plot(tv, f, '-r') % Tangent Line                                        
plot(t(idx), y(idx), '.r') % Maximum Vertical
hold off
grid

K = 1;
Tu = 1.7;
Tg = 6.7;
t = 1:0.1:60;

% P controller 0% overshoot
K_new = (0.3*Tg)/(K*Tu);
P = pidstd(K_new);
F = feedback(P*H,1);
figure()
step(F,t)
grid

% PI controller 0% overshoot
K_new = (0.35*Tg)/(K*Tu);
Ti = 1.2*Tg;
P = pidstd(K_new,Ti);
F = feedback(P*H,1);
figure()
step(F,t)
grid

% PID controller 0% overshoot
K_new = (0.6*Tg)/(K*Tu);
Ti = Tg;
Td = 0.5*Tu;
P = pidstd(K_new,Ti,Td);
F = feedback(P*H,1);
figure()
step(F,t)
grid

% P controller 20% overshoot
K_new = (0.7*Tg)/(K*Tu);
P = pidstd(K_new);
F = feedback(P*H,1);
figure()
step(F,t)
grid

% PI controller 20% overshoot
K_new = (0.6*Tg)/(K*Tu);
Ti = Tg;
P = pidstd(K_new,Ti);
F = feedback(P*H,1);
figure()
step(F,t)
grid

% PID controller 20% overshoot
K_new = (0.95*Tg)/(K*Tu);
Ti = 1.4*Tg;
Td = 0.47*Tu;
P = pidstd(K_new,Ti,Td);
F = feedback(P*H,1);
figure()
step(F,t)
grid