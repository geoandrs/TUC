clear 
close all
clc

syms x;

%% a <= 0 and a >= 1
figure
hold on
grid on
xlabel("$x$","Interpreter","latex")
ylabel("$f(x) = x^a$","Interpreter","latex")
for a = [-1 0 1 2]
    f(x) = x^a;
    fplot(f,[0.1,3],"DisplayName","a = "+a)
end
axis tight
legend

%% 0 <= a <= 1
figure
hold on
grid on
xlabel("$x$","Interpreter","latex")
ylabel("$f(x) = x^a$","Interpreter","latex")
for a = 0:0.2:1 
    f(x) = x^a;
    fplot(f,[0.1,2],"DisplayName","a = "+a)
end
axis tight
legend

%%
clear
syms x1 x2;
x = [x1 x2];

f1(x) = norm(x);
f2(x) = norm(x)^2;

figure
fmesh(f1,[-1 1 -1 1],'EdgeColor','k','FaceColor','interp')
xlabel("$x_1$","Interpreter","latex")
ylabel("$x_2$","Interpreter","latex")
zlabel("$f_1(x_1,x_2)$","Interpreter","latex")
title("$f_1(\mathbf{x}) = \|\mathbf{x}\|_2$","Interpreter","latex")

figure
fmesh(f2,[-1 1 -1 1],'EdgeColor','k','FaceColor','interp')
xlabel("$x_1$","Interpreter","latex")
ylabel("$x_2$","Interpreter","latex")
zlabel("$f_2(x_1,x_2)$","Interpreter","latex")
title("$f_2(\mathbf{x}) = \|\mathbf{x}\|_2^2$","Interpreter","latex")





