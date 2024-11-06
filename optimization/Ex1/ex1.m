clear
close all
clc

syms x;

x_0 = [1 2 3]; % point to calculate the Taylor approximations

fx(x) = 1/(1+x); % fuction f(x)
fx_diff1(x) = diff(fx,x); % first derivative of f(x)
fx_diff2(x) = diff(fx,x,2); % second derivative of f(x)

for x0 = x_0
    
    % first order Taylor approximation
    f1order(x) = fx(x0)+fx_diff1(x0)*(x-x0); 
    % second order Taylor approximation
    f2order(x) = fx(x0)+fx_diff1(x0)*(x-x0)+(1/2)*fx_diff2(x0)*(x-x0)^2; 

    figure
    fplot(fx,[0 5])
    hold on
    fplot(f1order,[0 5])
    fplot(f2order,[0 5])
    xlabel("x")
    ylabel("y")
    legend("function","first order Taylor","second order Taylor")
    title("function with Taylor approximations in x_0 = "+x0)

end