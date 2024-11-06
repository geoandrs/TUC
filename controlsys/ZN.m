clear 
close all


Kpcrit = 8;
Tcrit  = 7.3;

s = zpk('s');

Ks = 1; T1 = 2; T2 = 2; T3 = 2;
% συνάρτηση μεταφοράς του συστήματος
H = Ks/((T1*s+1)*(T2*s+1)*(T3*s+1));
t = 1:0.1:60; % χρόνος για τα διαγράμματα
F = feedback(H,1) % μοναδιαία ανάδραση
figure()
step(F,t)
grid

P = pidstd(Kpcrit);
F = feedback(P*H,1);
figure()
step(F,t)
grid

% Find Kp,crit -> ameiwti talantwsi
% Kp,crit = 8
kp = 1:0.5:10; % τιμές Κp που πρέπει να ελέγξω
t = 1:0.1:60; % χρόνος για τα διαγράμματα
% ένα βοηθητικό διάνυσμα
step_response = zeros(length(kp),length(t));
i = 1;
for Kp = kp
    P = pidstd(Kp); % P ελεγκτής
    F = feedback(P*H,1); % μοναδιαία ανάδραση
    [y] = step(F,t);
    step_response(i,:) = y;
    i = i+1;
end
% πως τυπώθηκαν τα διαγράμματα σε ένα κοινό plot
figure()
for k = 1:length(kp)
    subplot(5,4,k)
    plot(t,step_response(k,:))
    title(['K_p = ',sprintf('%1.1f',kp(k))])
    xlabel('Time(second)')
    ylabel('Amplitude')
    grid
end

% P controller
P = pidstd(0.5*Kpcrit)
F = feedback(P*H,1)
figure()
step(F,t)
grid

% PI controller
P = pidstd(0.45*Kpcrit,0.85*Tcrit)
F = feedback(P*H,1)
figure()
step(F,t)
grid

% PID controller
P = pidstd(0.6*Kpcrit,0.5*Tcrit,0.12*Tcrit)
F = feedback(P*H,1)
figure()
step(F,t)
grid


