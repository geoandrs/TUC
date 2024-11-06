function x = markovChain(Pi_matrix,n)
%markovChain produce random data from markov chain

x = zeros(1,n);
x(1) = randi(5);
for k = 2:n
    x(k) = randsymb(1:5,Pi_matrix(:,x(k-1)),1);
end
end