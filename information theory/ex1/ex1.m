clear
close all
clc

epsilon = 0.05;

%% Question 1-2

p_values = [0.1 0.45];
n = 15;
x_min = -0.25e4;
x_max = 3.5e4;

for p = p_values
    typical_sequence_probability(p,n,epsilon,x_min,x_max)
end

%% Question 3-4

n = 50;
x_min = -1e14;
x_max = 12e14;
for p = p_values
    typical_sequence_probability(p,n,epsilon,x_min,x_max)
end

%% Question 5-7

n_values = 10:10:1000;
[H_x, lb, ub, num_of_typical] = typical_sequence_number(epsilon,n_values,p_values);
probability_of_typicals(epsilon,p_values,n_values);

bps = zeros(length(p_values),length(n_values));
for i_p = 1:length(p_values)
    bps(i_p,:) = log2(num_of_typical(i_p,:))./n_values;
end

figure
hold on;
grid on;
for i_p = 1:length(p_values)
    line([n_values(1) n_values(end)],[H_x(i_p) H_x(i_p)],'Color','b','DisplayName', sprintf('H(x)'));
    line([n_values(1) n_values(end)],[lb(i_p) lb(i_p)],'Color','r','DisplayName', sprintf('low bound'));
    line([n_values(1) n_values(end)],[ub(i_p) ub(i_p)],'Color','k','DisplayName', sprintf('upper bound'));
    plot(n_values,bps(i_p,:),'DisplayName', sprintf('bps for p = %.2f',p_values(i_p)))
end
legend

