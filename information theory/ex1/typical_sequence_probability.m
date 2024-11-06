% p = probability of Xi = 1 -> P(Xi = 1) = p
% n = number of Xi
% x_min/x_max = x axis limits 
function typical_sequence_probability(p,n,epsilon,x_min,x_max)

H_x = -p*log2(p) - (1-p)*log2(1-p); % entropy

lbound = 2^(-n*(H_x+epsilon)); % lower bound of probability of typical sequence
ubound = 2^(-n*(H_x-epsilon)); % upper bound of probability of typical sequence
prob_typical_seq = 2^(-n*H_x); % probability of typical sequence

i = 0:n; % number of ones in the sequence
prob_total = (p.^i).*((1-p).^(n-i)); % probability based on the number of ones in the sequence

figure
start = 1;
num_of_seq = nchoosek(n,1);
finish = start+num_of_seq; 
semilogy(start:finish,prob_total(1)*ones(1,num_of_seq+1))
hold on;
for j = 1:n
    num_of_seq = nchoosek(n,j);
    finish = start+num_of_seq;
    line([start finish], [prob_total(j+1) prob_total(j+1)],'Color','b')
    start = finish;
end
line([1 finish], [lbound lbound],'Color','r')
line([1 finish], [ubound ubound],'Color','g')
line([1 finish], [prob_typical_seq prob_typical_seq],'Color','k')
grid on;
xlim([x_min x_max])
title("p = "+p+" n = "+n)
xlabel("i-th sequence")
ylabel("probability of i-th sequence")
end

