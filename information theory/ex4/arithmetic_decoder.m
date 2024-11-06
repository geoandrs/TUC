function X_decode = arithmetic_decoder(y,p,N)

Low = 0;
High = 1;
D = High - Low;

Lx = 0;
Hx = 1;
Dx = Hx - Lx;

X_decode_ind = 0;
y_r = 0;
X = [0 1];
y_index = length(y);
X_decode = zeros(1,2*N);

Fx(1) = 0;
Fx(2) = 1-p;
Fx(3) = 1;

Y_decode_ind=1;
while Y_decode_ind <= y_index
    High = Low + D/2*(y(Y_decode_ind) + 1);    
    Low = Low + D/2*y(Y_decode_ind);
    D = High - Low;
    L_tmp = (Low - Lx)/Dx;
    H_tmp = (High - Lx)/Dx;
    L1_index = max(find(L_tmp >= Fx));
    H_move = Fx(L1_index + 1);
    while (H_tmp <= H_move)
        X_decode_ind = X_decode_ind + 1;
        Hx = Lx + Dx*(Fx(X(L1_index) + 2));        
        Lx = Lx + Dx*(Fx(X(L1_index) + 1));        
        X_decode(X_decode_ind) = X(L1_index);
        Dx = Hx - Lx;
        flag = 1;        
        while flag
            if Hx <= (1/2)
                Lx = 2*Lx;
                Hx = 2*Hx;
                Dx = Hx - Lx;
                y_r = y_r + 1;
                Low = 2*Low;
                High = 2*High;                
                D = High - Low;            
            elseif Lx >= (1/2)
                Lx = 2*Lx-1;
                Hx = 2*Hx-1;
                Dx = Hx - Lx;
                y_r = y_r + 1;
                High = 2*High - 1;
                Low = 2*Low - 1;
                D = High - Low;
            else
                flag = 0;
            end
        end
        L_tmp = (Low - Lx)/Dx;
        H_tmp = (High - Lx)/Dx;
        L1_index = max(find(L_tmp >= Fx));
        H_move = Fx(L1_index + 1);
    end
    Y_decode_ind = Y_decode_ind + 1;
end
X_decode = X_decode(1:N);