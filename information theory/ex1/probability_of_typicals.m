function probability_of_typicals(epsilon,p_values,n_values)

lprob = 1-epsilon; % lowest probability of a typical sequence
n = n_values; % n values
prob = zeros(length(p_values),length(n_values));
i_p = 1;
for p = p_values
    H_x = -p*log2(p) - (1-p)*log2(1-p); % entropy
    j = 1;
    for i_n = n
        prob_ubound = 2^(-i_n*(H_x-epsilon));
        prob_lbound = 2^(-i_n*(H_x+epsilon));

        k = 0:i_n;
        seq_prob = (p.^k).*(1-p).^(i_n-k); % probability of sequence

        typical_cdf = binocdf(k,i_n,p); % probability of sequence
        idx = find(seq_prob >= prob_lbound & seq_prob <= prob_ubound);
        prob(i_p,j) = typical_cdf(idx(end)) - typical_cdf(idx(1));
        j = j+1;
    end
    i_p = i_p + 1;
end
figure;
plot(n,prob(1,:),'Color','b','DisplayName', sprintf('p = %.2f',p_values(1)));
hold on;
grid on;
line([n(1) n(end)],[lprob lprob],'Color','r','DisplayName', sprintf('1-eps'));
for q = 2:length(p_values)
    plot(n,prob(q,:),'DisplayName', sprintf('p = %.2f',p_values(q)));
end
xlabel('n');
ylabel('Typical Sequence Probability');
legend('Location','southeast');
end

