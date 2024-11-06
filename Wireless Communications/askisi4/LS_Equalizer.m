function [fls] = LS_Equalizer(yw,n1,n2,Delta,order,ntrain)

    Yrow = yw(n1+Delta-1:-1:n1+Delta-order-1);
    Ycol = yw(n1+Delta-1:n2+Delta-1);
    Y = toeplitz(Ycol,Yrow); % toeplitz matrix for Least Squares Equalizer

    fls = pinv(Y)*(ntrain.'); % Least Squares Equalizer

end

