clear 
close all
clc
rng(1234) % K = 100

%% i
n = 2; % number of dimention of variable x 
A = randn(n,n); % random matrix used to construct matrix U

% eigenvector of P
[U,S,V] = svd(A); % singular value decomposition

% construct matrix Lambda
S = diag(S);
l_min = min(S);
l_max = max(S);
z = l_min + (l_max-l_min)*rand(n-2,1);

% eigenvalues of P
eig_P = [l_min;l_max;z];
L = diag(eig_P); % in case of n=2 then L is equivalent to S

%% ii
K = 100; % condition number of the problem

% eigenvalues of P
% linear stretch of existing S matrix
eig_P = l_max *(1-((K-1)/K)*(l_max -S)/(l_max -l_min));
L = diag(eig_P); % in case of n=2 then L is equivalent to S

cond(L) % check condition number
% construct matrix P and vector q
P = U*L*U';
q = rand(n,1);

%% iii - CLOSE FORM SOLUTION

x_opt = -P\q % optimal point 
p_opt = (1/2)*(x_opt.')*P*x_opt + (q.')*x_opt % optimal value

%% iv - CVX SOLUTION

cvx_begin
   variable x(n)
   minimize ((1/2)*quad_form(x,P)+q.'*x)
cvx_end
cvx_x_opt = x % optimal point using cvx
cvx_p_opt = cvx_optval % optimal value using cvx

%% v
%%%%%%%%%%%%%%%%   EXACT LINE SEARCH    %%%%%%%%%%%%%%%%%%%%%%
xk = [3;4]; % random point selection
f_xk = (1/2)*(xk.')*P*xk + (q.')*xk;
grad_xk = -P*xk-q;
iter = 0;
epsilon = 1e-5; % tolerance
condition = norm(grad_xk);
while condition > epsilon
    if iter ~= 0
        grad_xk(:,end+1) = -P*xk(:,end)-q;
    end
    % t_star is calculated in notes in closed form and we use it here
    t_star = norm(grad_xk(:,end))^2/(grad_xk(:,end).'*P*grad_xk(:,end));
    xk(:,end+1) = xk(:,end)+t_star*grad_xk(:,end); 
    f_xk(end+1) = (1/2)*(xk(:,end).')*P*xk(:,end) + (q.')*xk(:,end);
    iter = iter + 1;
    condition = norm(-P*xk(:,end)-q);
end
x_opt_exact_line = xk(:,end) % optimal point exact line search
p_opt_exact_line = f_xk(end) % optimal value exact line search

% multiply with -1 to have the right values of gradients

%%%%%%%%%%%%%%%%   BACKTRACKING LINE SEARCH    %%%%%%%%%%%%%%%%%%%%%%

xk_btr = xk(:,1); % start from the same random point
f_xk_btr = f_xk(1);
grad_xk_btr = grad_xk(:,1); % same gradient value for the same point
epsilon = 1e-5; % tolerance
alpha = 0.3;
beta = 0.7;
iter_btr = 0;
condition = norm(grad_xk_btr);
while condition > epsilon
    iter_btr = iter_btr + 1;
    t = 1; % initial value of stepsize
    % predefine some variables to be easier to understand
    grad = -P*xk_btr(:,end)-q;
    x_new = xk_btr(:,end)+t*grad;
    fun_val_new = (1/2)*(x_new.')*P*x_new + (q.')*x_new;
    while f_xk_btr(end)-fun_val_new < -alpha*t*(norm(grad)^2)
        t = beta*t;
        x_new = xk_btr(:,end)+t*grad;
        fun_val_new = (1/2)*(x_new.')*P*x_new + (q.')*x_new;
    end
    xk_btr(:,end+1) = xk_btr(:,end)+t*grad;
    f_xk_btr(end+1) = (1/2)*(xk_btr(:,end).')*P*xk_btr(:,end) + (q.')*xk_btr(:,end);
    grad_xk_btr(:,end+1) = -P*xk_btr(:,end)-q;
    condition = norm(grad_xk_btr(:,end));
end
x_opt_backtracking = xk_btr(:,end) % optimal point backtracking line search
p_opt_backtracking = f_xk_btr(end) % optimal value backtracking line search

% multiply with -1 to have the right values of gradients

%% vi
% exact line search contour
ll = 100;
x_min = min(xk(1,:));
x_max = max(xk(1,:));
x_contour = linspace(x_min,x_max,ll);

y_min = min(xk(2,:));
y_max = max(xk(2,:));
y_contour = linspace(y_min,y_max,ll);

for i = 1:ll
    for j = 1:ll
        vec = [x_contour(i);y_contour(j)];
        z_contour(i,j) = (1/2)*(vec.')*P*vec + (q.')*vec;
    end
end

figure
contour(x_contour,y_contour,z_contour,f_xk,'HandleVisibility','off')
hold on; grid on 
plot(xk(1,:),xk(2,:),'ro-','DisplayName','exact')
plot(xk_btr(1,:),xk_btr(2,:),'ko-','DisplayName','backtracking')
xlabel('$x_1$','FontSize',20,'Interpreter','latex')
ylabel('$x_2$','FontSize',20,'Interpreter','latex')
title("line search K = "+K)
legend

%% vii

figure
plot(0:iter,log(f_xk-p_opt_exact_line))
hold on; grid on
plot(0:iter_btr,log(f_xk_btr-p_opt_backtracking))
xlabel("iterations",'FontSize',20,'Interpreter','latex')
ylabel('$$log(f(\mathbf{x}_k)-p_*)$$','FontSize',20,'Interpreter','latex')
legend("Exact", "Backtracking")

