clear all
close all

dt = 0.001;
t = [0:dt:0.5];

%create the continuous signal x
x = 5*cos(24*pi*t)-2*sin(1.5*pi*t);
figure(1)
plot(t,x)
title("Sampling with Fs = 48Hz")
xlabel("t(ms)")
ylabel("amplitude");

%Sampling with Fs = 48Hz
Ts1 = 1/48;
td1 = [t(1):Ts1:t(end)];
xd1 = 5*cos(24*pi*td1)-2*sin(1.5*pi*td1);
hold on
plot(td1,xd1,"r*")
hold off

figure(2)
plot(t,x)
title("Sampling with Fs = 24Hz")
xlabel("t(ms)")
ylabel("amplitude");

%Sampling with Fs = 24Hz
Ts2 = 1/24;
td2 = [t(1):Ts2:t(end)];
xd2 = 5*cos(24*pi*td2)-2*sin(1.5*pi*td2);
hold on
plot(td2,xd2,"r*")
hold off

figure(3)
plot(t,x)
title("Sampling with Fs = 12Hz")
xlabel("t(ms)")
ylabel("amplitude");

%Sampling with Fs = 12Hz
Ts3 = 1/12;
td3 = [t(1):Ts3:t(end)];
xd3 = 5*cos(24*pi*td3)-2*sin(1.5*pi*td3);
hold on
plot(td3,xd3,"r*")
hold off

figure(4)
plot(t,x)
title("Sampling with Fs = 15Hz")
xlabel("t(ms)")
ylabel("amplitude");

%Sampling with Fs = 15Hz
Ts4 = 1/15;
td4 = [t(1):Ts4:t(end)];
xd4 = 5*cos(24*pi*td4)-2*sin(1.5*pi*td4);
hold on
plot(td4,xd4,"r*")
hold off
