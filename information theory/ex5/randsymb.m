function x = randsymb(symbols,probabilities,n)
%RANDSYMB Generate random symbols given distribution.

cumulative = cumsum(probabilities);
R = rand(n,1);
fun = @(r) find(r<cumulative,1);        % function: find the 1st index s.t. r<cumulative(i);
indexes = arrayfun(fun,R);              % get symbol indexes
x = symbols(indexes);
end