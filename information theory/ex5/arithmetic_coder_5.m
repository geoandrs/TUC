function y = arithmetic_coder_5(x,p,previous_symbol)

Fx(1,1)=0;
Fx(1,2)=0;
Fx(2,1)=1-p(1);
Fx(2,2)=1-p(2);
Fx(3,1)=1;
Fx(3,2)=1;

N=length(x); % size of the file

y=zeros(1,N); % fill with zeros as many as the size of the file
y_index = 0;

High = 1;
Low = 0;

nn = 1;
while nn <= N
    D = High - Low;
    High = Low + D*Fx(x(nn) + 2,previous_symbol);    
    Low = Low + D*Fx(x(nn) + 1,previous_symbol);             
    flag = 1;
    while flag
        if Low >= (1/2)
            y_index = y_index + 1;
            y(y_index) = 1;
            High = 2*High - 1;
            Low = 2*Low - 1;
        elseif High <= (1/2) 
            y_index = y_index + 1;
            y(y_index) = 0;
            High = 2*High;
            Low = 2*Low;            
        else
            flag = 0;
        end
    end
    previous_symbol = x(nn)+1;
    nn = nn + 1;    
end

F = (Low + High)/2;
if F < (1/2)
    y_index = y_index + 1;
    y(y_index) = 0;
    Low = 2*Low;
    F = 2*F;
    flag = 1;
    while flag
        y_index = y_index + 1;
        if F<(1/2)
            y(y_index) = 0;
            Low = 2*Low;
            F = 2*F;
        else
            y(y_index) = 1;
            if Low>=(1/2)
                Low = 2*Low - 1;
                F = 2*F - 1;
            else
                flag = 0;
            end
        end
    end
else
    y_index = y_index + 1;
    y(y_index) = 1;
    High = 2*High - 1;
    F = 2*F - 1;
    flag = 1;
    while flag
        y_index = y_index + 1;
        if F>=(1/2)
            y(y_index) = 1;
            High = 2*High - 1;
            F = 2*F-1;
        else
            y(y_index) = 0;
            if High<(1/2)
                High = 2*High;
                F = 2*F;
            else
                flag = 0;
            end
        end
    end
end    

y = y(1:y_index);