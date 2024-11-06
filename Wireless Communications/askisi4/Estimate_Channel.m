function [h_est] = Estimate_Channel(s,n1,n2,K,yw)

    Arow = s(n1+K:-1:n1);
    Acol = s(n1+K:n2);
    A = toeplitz(Acol,Arow); % toeplitz matrix for channel estimation

    y_est = yw(n1+K:n2).'; % output vector for channel estimation

    h_est = pinv(A)*y_est; % estimated channel
    
end

