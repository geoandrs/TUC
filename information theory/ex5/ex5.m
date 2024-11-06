clear
close all
clc

p = [0.05 0.95; 0.55 0.45];
Pi_matrix = sym(p);

%% Convergence Distribution
[V, D] = eig(Pi_matrix')

ix = find(isAlways(diag(D) == 1,'Unknown','error'));
for k = ix'
    V(:,k) = V(:,k)/norm(V(:,k),1);
end
p_X_inf = double(V(:,ix))

%% Entropy

entropy = 0;
for k = 1:length(p_X_inf)
    entropy = entropy - p_X_inf(k)*log2(p_X_inf(k));
end
entropy

%% Entropy rate

entropy_rate = 0;
for k = 1:length(p_X_inf)
    for l = 1:length(p_X_inf)
        entropy_rate = entropy_rate - p_X_inf(k)*p(k,l)*log2(p(k,l));
    end
end
entropy_rate

%% x

n_monte_carlo = 1e3;
n_values = [10 : 5 : 100 200 : 200 : 800];
Pi_matrix = [0.05 0.55;
    0.95 0.45];

%% 5.3a
i_n = 1;
ber = zeros(1,length(n_values));
len_mean = zeros(1,length(n_values));
for n = n_values
    for i = 1:n_monte_carlo
        x = markovChain5(Pi_matrix,n,p_X_inf);
        y = arithmetic_coder(x,p_X_inf(2));
        x_dec = arithmetic_decoder(y,p_X_inf(2),n);
        ber(i_n) = ber(i_n) + sum(abs(x-x_dec));
        len_mean(i_n) = len_mean(i_n) + length(y)/n/n_monte_carlo;
    end
    i_n = i_n + 1;
end
ber_tot = sum(ber)/n/n_monte_carlo;
if (ber_tot) ~= 0
    disp("Not correct")
end

figure
plot(n_values,len_mean,'DisplayName',"mean length")
hold on; grid on;
plot(n_values,entropy*ones(1,length(n_values)),'DisplayName',"entropy")
plot(n_values,entropy_rate*ones(1,length(n_values)),'DisplayName',"entropy rate")
xlabel("n")
title("p(x_{inf})")
legend

%% 5.3b
i_n = 1;
ber = zeros(1,length(n_values));
len_mean = zeros(1,length(n_values));
for n = n_values
    for i = 1:n_monte_carlo
        x = markovChain5(Pi_matrix,n,p_X_inf);
        previous_symbol = 1*(rand > p_X_inf(1))+1;
        y = arithmetic_coder_5(x,Pi_matrix(2,:),previous_symbol);
        x_dec = arithmetic_decoder_5(y,Pi_matrix(2,:),n,previous_symbol);
        ber(i_n) = ber(i_n) + sum(abs(x-x_dec));
        len_mean(i_n) = len_mean(i_n) + length(y)/n/n_monte_carlo;
    end
    i_n = i_n + 1;
end
ber_tot = sum(ber)/n/n_monte_carlo;
if (ber_tot) ~= 0
    disp("Not correct")
end

figure
plot(n_values,len_mean,'DisplayName',"mean length")
hold on; grid on;
plot(n_values,entropy*ones(1,length(n_values)),'DisplayName',"entropy")
plot(n_values,entropy_rate*ones(1,length(n_values)),'DisplayName',"entropy rate")
xlabel("n")
title("p(x_n|x_{n-1})")
legend