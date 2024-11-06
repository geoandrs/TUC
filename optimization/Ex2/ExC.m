clear
close all
clc

n = 2;
m = 20;

c = rand(n,1);
b = 10*rand(m,1); % multiplied *10 to be sure we have solution
A = randn(m,n);


%% a - CVX solution

cvx_begin
    variable x(n)
    minimize (c.'*x - sum(log(b-A*x)))
    subject to
        (b-A*x > 0)
cvx_end

x_opt_cvx = x
p_opt_cvx = cvx_optval

%% b - plot f and level sets

x_axis = x_opt_cvx(1)-0.1:0.001:x_opt_cvx(1)+0.1;
y_axis = x_opt_cvx(2)-0.1:0.001:x_opt_cvx(2)+0.1;
f = NaN(length(x_axis),length(y_axis));
for i = 1:length(x_axis)
    for j = 1:length(y_axis)
        x_test = [x_axis(i);y_axis(j)];
        if (b>A*x_test)
            f(i,j) = (c.'*x_test - sum(log(b-A*x_test)));
        else
            f(i,j) = 1e3;
        end
    end
end

figure
mesh(x_axis,y_axis,f)
xlabel("$x_1$","Interpreter","latex","FontSize",15)
ylabel("$x_2$","Interpreter","latex","FontSize",15)
zlabel("$f(x_1,x_2)$","Interpreter","latex","FontSize",15)
title("Mesh plot of $f(x_1,x_2)$ near optimal point","Interpreter",...
    "latex","FontSize",15)

figure
contour(x_axis,y_axis,f)
xlabel("$x_1$","Interpreter","latex","FontSize",15)
ylabel("$x_2$","Interpreter","latex","FontSize",15)
zlabel("$f(x_1,x_2)$","Interpreter","latex","FontSize",15)
title("Contour plot of $f(x_1,x_2)$ near optimal point","Interpreter",...
    "latex","FontSize",15)

%% backtracking line search

xk_btr = zeros(n,1);% start point
f_xk_btr = c.'*xk_btr - sum(log(b-A*xk_btr));
grad_xk_btr = gradf(A,b,c,xk_btr); % same gradient value for the same point
epsilon = 1e-5; % tolerance
alpha = 0.3;
beta = 0.7;
iter_btr = 0;
condition = norm(grad_xk_btr);
while condition > epsilon
    iter_btr = iter_btr + 1;
    t = 1; % initial value of stepsize
    % predefine some variables to be easier to understand
    x_new = xk_btr(:,end)-t*grad_xk_btr(:,end);
    while any(b <= A*x_new)
        t = beta*t;
        x_new = xk_btr(:,end)-t*grad_xk_btr(:,end);
    end

    fun_val_new = c.'*x_new - sum(log(b-A*x_new));
    while f_xk_btr(end)-fun_val_new < alpha*t*(norm(grad_xk_btr(:,end))^2)
        t = beta*t;
        x_new = xk_btr(:,end)-t*grad_xk_btr(:,end);
        fun_val_new = c.'*x_new - sum(log(b-A*x_new));
    end
    xk_btr(:,end+1) = xk_btr(:,end)-t*grad_xk_btr(:,end);
    f_xk_btr(end+1) = c.'*xk_btr(:,end) - sum(log(b-A*xk_btr(:,end)));
    grad_xk_btr(:,end+1) = gradf(A,b,c,xk_btr(:,end));
    condition = norm(grad_xk_btr(:,end));
end
x_opt_backtracking = xk_btr(:,end) % optimal point backtracking line search
p_opt_backtracking = f_xk_btr(end) % optimal value backtracking line search


%% d - Newton algotrithm

xn = zeros(n,1);
f_xn = c.'*xn - sum(log(b-A*xn));
epsilon = 1e-5;
iter_newton = 0;
while true
    
    grad = gradf(A,b,c,xn(:,end));
    hessian = Hessian(A,b,xn(:,end));
    Dxn = -hessian\grad;
    lambda_square = (grad.')*(hessian\grad);

    if lambda_square/2 <= epsilon
        break
    end
    
    iter_newton = iter_newton + 1;
    
    t = 1;
    x_new = xn(:,end)-t*grad;
    while any(b <= A*x_new)
        t = beta*t;
        x_new = xn(:,end)-t*grad;
    end

    fun_val_new = c.'*x_new - sum(log(b-A*x_new));
    val = f_xn(end) - fun_val_new - alpha*t*(norm(grad)^2);
    while val < 0
        t = beta*t;
        x_new = xn(:,end)-t*grad;
        fun_val_new = c.'*x_new - sum(log(b-A*x_new));
        val = f_xn(end) - fun_val_new - alpha*t*(norm(grad)^2);
    end

    xn(:,end+1) = xn(:,end)+t*Dxn;
    f_xn(end+1) = c.'*xn(:,end) - sum(log(b-A*xn(:,end)));

end
x_opt_newton = xn(:,end) % optimal point newton algorithm
p_opt_newton = f_xn(end) % optimal value newton algorithm

%% e - semilogy 

figure
semilogy(0:iter_btr,f_xk_btr-p_opt_backtracking,'DisplayName','backtrack')
hold on; grid on 
semilogy(0:iter_newton,f_xn-p_opt_newton,'DisplayName','Newton')
xlabel("k","Interpreter","latex","FontSize",15)
ylabel("log$(f(x_k)-p_{*})$","Interpreter","latex","FontSize",15)
string = "n = "+n+", m = "+m;
title(string,"Interpreter","latex","FontSize",15)
legend

%% functions 
function grad = gradf(A,b,c,x)
grad = 0;
for k = 1:length(b)
    ai = A(k,:);
    grad = grad + (ai.') / (b(k)-ai*x);
end
grad = c + grad;
end

function hessian = Hessian(A,b,x)
hessian = 0;
for k = 1:length(b)
    ai = A(k,:);
    hessian = hessian + (ai.')*ai / (b(k)-ai*x)^2;
end
end