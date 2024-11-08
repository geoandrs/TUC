clear 
close all
clc

%% 2.a
x_star = 10; % end point for x1, x2
[x1,x2] = meshgrid(0:0.01:x_star); % generate x1, x2
f = 1./(1+x1+x2); % the function we want to plot

figure
mesh(x1,x2,f)
title("Plot of function for x_{*} = "+10)
xlabel("x")
ylabel("y")
zlabel("z")

%% 2.b

figure
contour(x1,x2,f)
title("Level sets of function for x_{*} = "+10)
xlabel("x")
ylabel("y")
zlabel("z")

%% 2.c

syms x_1 x_2;

x01 = 2; x02 = 2; % point to calculate Taylor approximations
xx = [x_1; x_2]; % vector of my variables
x0 = [x01; x02]; % point to calculate Taylor approximations

fx(x_1,x_2) = 1/(1+x_1+x_2); % function f(x)

gradf(x_1,x_2) = [diff(fx,x_1); diff(fx,x_2)] % gradient of function f(x)

A(x_1,x_2) = diff(fx,x_1,2); % partial second derivative over x1
D(x_1,x_2) = diff(fx,x_2,2); % partial second derivative over x2
% partial second derivative over x1 and x2
B_tmp(x_1,x_2) = diff(fx,x_1); B(x_1,x_2) = diff(B_tmp,x_2);
C_tmp(x_1,x_2) = diff(fx,x_2); C(x_1,x_2) = diff(C_tmp,x_1);

sec_gradf(x_1,x_2) = [A B; C D]

f1order = fx(x01,x02)+(gradf(x01,x02)')*(xx-x0)
f2order = fx(x01,x02)+(gradf(x01,x02)')*(xx-x0)+(1/2)*(xx-x0)'*sec_gradf(x01,x02)*(xx-x0)

%% 2d

figure
fmesh(f1order,[0 x_star 0 x_star],'EdgeColor','b')
hold on 
scatter3(x01,x02,fx(x01,x02),'filled','k')
mesh(x1,x2,f,'EdgeColor','r')
title("Plot of function and first order Taylor approximation")
xlabel("x")
ylabel("y")
zlabel("z")

%% 2e

figure
fmesh(f2order,[0 x_star 0 x_star],'EdgeColor','b')
hold on 
scatter3(x01,x02,fx(x01,x02),'filled','k')
mesh(x1,x2,f,'EdgeColor','r')
title("Plot of function and second order Taylor approximation")
xlabel("x")
ylabel("y")
zlabel("z")
