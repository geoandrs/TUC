function [est_X] = detect_4_PAM(Y,A)
    
    est_X = zeros(1,length(Y));
    
    X00 = 3*A;
    X01 = A;
    X11 = -A;
    X10 = -3*A;

    for i = 1:length(Y)
        
        dist1 = abs(Y(i)-X00);
        dist2 = abs(Y(i)-X01);
        dist3 = abs(Y(i)-X11);
        dist4 = abs(Y(i)-X10);
        
        min_value = min([dist1 dist2 dist3 dist4]);
        if(dist1 == min_value)
            est_X(i) = X00;
        elseif(dist2 == min_value)
            est_X(i) = X01;
        elseif(dist3 == min_value)
            est_X(i) = X11;
        elseif(dist4 == min_value)
            est_X(i) = X10;
        else
            disp("Error");
            return
        end
    end

end

