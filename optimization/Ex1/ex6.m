clear 
close all
clc

A = randn(2,2);
P = A*A'; % calculate P matrix as shown in exercise
q = randn(2,1); % random 1x2 vector q
r = randn; % random constant r

syms x1 x2;
x = [x1;x2];

f(x) = (1/2)*(x.')*P*x + (q.')*x + r; % function f(x1,x2)

xst = -P\q; % x_star -> optimal point

figure
scatter3(xst(1),xst(2),f(xst(1),xst(2)),'k','filled')
hold on
grid on
fmesh(f,[xst(1)-2 xst(1)+2 xst(2)-2 xst(2)+2],'FaceColor','interp')
xlabel("$x_1$","Interpreter","latex")
ylabel("$x_2$","Interpreter","latex")
zlabel("$f_1(x_1,x_2)$","Interpreter","latex")
colorbar

figure
scatter(xst(1),xst(2),'k','filled')
hold on
grid on
fcontour(f,[xst(1)-2 xst(1)+2 xst(2)-2 xst(2)+2])
colorbar
axis tight
xlabel("$x_1$","Interpreter","latex")
ylabel("$x_2$","Interpreter","latex")