function x = markovChain5(Pi_matrix,n,p_X_inf)
%markovChain produce random data from markov chain for exercise 5

x = zeros(1,n);
x(1) = 1*(rand > p_X_inf(1));
for k = 2:n
    x(k) = randsymb(0:1,Pi_matrix(:,x(k-1)+1),1);
end
end