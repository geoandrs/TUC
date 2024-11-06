function X_decode = arithmetic_decoder_5(y,p,N,previous_symbol)

Low = 0;
High = 1;
D = High - Low;

Lx = 0;
Hx = 1;
Dx = Hx - Lx;

X_decode_ind = 1;
X = [0 1];
y_index = length(y);
X_decode = zeros(1,2*N);

Fx(1,1)=0;
Fx(1,2)=0;
Fx(2,1)=1-p(1);
Fx(2,2)=1-p(2);
Fx(3,1)=1;
Fx(3,2)=1;

for Y_decode_ind = 1:y_index
    
    High = Low + (D/2)*(y(Y_decode_ind) + 1);
    Low = Low + (D/2)*y(Y_decode_ind);
    D = High - Low;
    
    L1_index = max(find((Low - Lx)/Dx >= Fx(:,previous_symbol)));
    if L1_index == 3
        L1_index = 2;
    end
    while ((High - Lx)/Dx <= Fx(L1_index+1,previous_symbol))
        X_decode(X_decode_ind) = X(L1_index);
        X_decode_ind = X_decode_ind + 1;
        
        Hx = Lx + Dx*(Fx(X(L1_index) + 2,previous_symbol));
        Lx = Lx + Dx*(Fx(X(L1_index) + 1,previous_symbol));
        Dx = Hx - Lx;
        flag = 1;
        while flag
            if Hx <= (1/2)
                Lx = 2*Lx;
                Hx = 2*Hx;
                Dx = Hx - Lx;
                Low = 2*Low;
                High = 2*High;
                D = High - Low;
            elseif Lx >= (1/2)
                Lx = 2*Lx-1;
                Hx = 2*Hx-1;
                Dx = Hx - Lx;
                High = 2*High - 1;
                Low = 2*Low - 1;
                D = High - Low;
            else
                flag = 0;
            end
        end
        previous_symbol = X_decode(X_decode_ind-1) + 1;
        L1_index = max(find((Low - Lx)/Dx >= Fx(:,previous_symbol)));
        if L1_index == 3
            L1_index = 2;
        end
    end
end
X_decode = X_decode(1:N);