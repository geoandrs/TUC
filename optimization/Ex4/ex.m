clear
close all
clc

%% Initialization

p = 1; % first dimension - rank of matrix A
n = 2; % second dimension

c = rand(n,1); % random vector
x_rand = rand(n,1); % random non negative x to calculate b
A = randn(p,n); % matrix A
b = A*x_rand; % vector b

%% CVX solution
 
cvx_begin
    variable x(n)
    minimize (c.'*x)
    subject to
        A*x-b == 0
        -x <= 0
cvx_end

x_cvx = x; % optimal point
p_cvx = cvx_optval; % optimal value

%% feasible initial point
cvx_begin
    variable x(n)
    minimize (0)
    subject to
        A*x-b == 0
        -x <= 0
cvx_end

%% logarithmic barrier algorithm 

threshold_1 = 1e-6;
threshold_2 = 1e-6;
alpha = 0.1; beta = 0.7; % backtracking parameters
mu = 2; % parameter for increasing t

x_init(:,1) = x; % initial point 
t = 1;

outer_iter = 1;
X(:,outer_iter) = x_init;
while true

    xnt(:,1) = X(:,outer_iter);
    inner_iter = 1;

    while true

        grad = c - (1/t)./xnt(:,inner_iter);
        hessian = diag((1/t)./(xnt(:,inner_iter).^2));
        w = - (A*(hessian\A.'))\(A*(hessian\grad));
        Dx_Nt = -hessian\(grad+A.'*w);
        lx = (grad.')*(-Dx_Nt);

        if lx/2 <= threshold_1
            break
        end

        tau = 1;
        x_new = xnt(:,inner_iter) + tau*Dx_Nt;
        while any(x_new < 0)
            tau = beta * tau;
            x_new = xnt(:,inner_iter) + tau*Dx_Nt;
        end

        fnew = c.'*x_new - (1/t)*sum(log(x_new));
        fx = c.'*xnt(:,inner_iter) - (1/t)*sum(log(xnt(:,inner_iter)));
        while fnew > fx + alpha*tau*(grad.')*Dx_Nt
            tau = beta * tau;
            x_new = xnt(:,inner_iter) + tau*Dx_Nt;
            fnew = c.'*x_new - (1/t)*sum(log(x_new));
        end

        xnt(:,inner_iter+1) = xnt(:,inner_iter) + tau*Dx_Nt;
        inner_iter = inner_iter + 1;

    end

    X(:,outer_iter+1) = xnt(:,inner_iter);
    if (1/t < threshold_2)
        break
    end
    outer_iter = outer_iter + 1;
    t = t * mu;

end

x_logbar = X(:,end);
p_logbar = c.'*X(:,end) - (1/t)*sum(log(X(:,end)));

%% Primal-dual algorithm 

clear mu t

e_feas = 1e-6;
e_th = 1e-6;
m = 1;
mu = 10;

xpd = x_init;%rand(n,1);
lambda = rand(n,1);
v = rand(p,1);

hat_h = xpd'*lambda;
t = mu*m/hat_h;

r_td = c - lambda + A'*v;
r_tp = A*xpd - b;
r_tc = diag(lambda)*xpd - (1/t);
r_t = [r_td; r_tc; r_tp];

x_pd_all(:,1) = xpd;

while (norm(r_tp) > e_feas || norm(r_td) > e_feas || hat_h > e_th)

    Drt = zeros(2*n+p);
    Drt(1:n, n+1:2*n) = -eye(n);
    Drt(1:n, 2*n+1:end) = A';
    Drt(n+1:2*n, 1:n) = diag(lambda);
    Drt(n+1:2*n, n+1:2*n) = diag(xpd);
    Drt(2*n+1:end, 1:n) = A;

    Dy_pd = -Drt\r_t;

    vv = 1;
    for i = length(lambda)
        if Dy_pd(n+i) < 0
            vv(end+1) = -lambda(i)/Dy_pd(n+i);
        end
    end
    s_max = min(vv);

    s = 0.99*s_max;
    x_plus = xpd + s*Dy_pd(1:n);
    while any(x_plus < 0)
        s = beta*s;
        x_plus = xpd + s*Dy_pd(1:n);
    end

    lambda_plus = lambda + s*Dy_pd(n+1:2*n);
    v_plus = v + s*Dy_pd(2*n+1:end);

    hat_h = x_plus'*lambda_plus;
    t = mu*m/hat_h;

    r_td_plus = c - lambda_plus + A'*v_plus;
    r_tp_plus = A*x_plus - b;
    r_tc_plus = diag(lambda_plus)*x_plus - 1/t;
    r_t_plus = [r_td_plus; r_tc_plus; r_tp_plus];

    while norm(r_t_plus) > (1-alpha*s)*norm(r_t)
        s = beta*s;
        x_plus = xpd + s*Dy_pd(1:n);
        lambda_plus = lambda + s*Dy_pd(n+1:2*n);
        v_plus = v + s*Dy_pd(2*n+1:end);

        hat_h = x_plus'*lambda_plus;
        t = mu*m/hat_h;

        r_td_plus = c - lambda_plus + A'*v_plus;
        r_tp_plus = A*x_plus - b;
        r_tc_plus = diag(lambda_plus)*x_plus - 1/t;
        r_t_plus = [r_td_plus; r_tc_plus; r_tp_plus];
    end

    xpd = x_plus;
    lambda = lambda_plus;
    v = v_plus;

    r_td = r_td_plus;
    r_tp = r_tp_plus;
    r_tc = r_tc_plus;
    r_t = r_t_plus;

    x_pd_all(:,end+1) = xpd;
end
x_pd = xpd;
p_pd = c.'*xpd;

%% print solutions of the 3 methods
n
p

x_cvx
p_cvx

x_logbar
p_logbar

x_pd
p_pd

%% plot nonnegative orthant, feasible set and trajectories
if p == 1 && n == 2
xk = max(round(x_init))+1; 
x1 = linspace(0,xk);
x2 = linspace(0,xk);
for jj = 1:length(x1)
    for kk = 1:length(x2)
        f(jj,kk) = c'*[x1(jj);x2(kk)];
    end
end         
figure
contour(x1,x2,f,"LineWidth",1.5)
hold on 
colorbar

h = @(x1, x2) A*[x1;x2]-b;
fimplicit(h,[0 xk],'LineWidth',2,'Color','magenta')

scatter(X(1,:),X(2,:),'red','filled')
scatter(x_pd_all(1,:),x_pd_all(2,:),'black','filled')
scatter(x_cvx(1),x_cvx(2),'cyan','filled')

legend("","feasible set","logaritmic barrier","primal-dual","optimal point")
xlabel("$x_1$",'Interpreter','latex','FontSize',14)
ylabel("$x_2$",'Interpreter','latex','FontSize',14)
end



