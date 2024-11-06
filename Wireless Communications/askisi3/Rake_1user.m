function [berr] = Rake_1user(L,N,ck,var_w)
        
        % channel
        hk = sqrt(1/(2*L))*(randn(L,1) + 1i*randn(L,1));
        % symbols = {+1,-1}
        s = sign(randn(1,N));
        
        x = zeros(1,N*N);
        for k = 1:N
            x(1,((k-1)*N+1):(k*N)) = s(k).*ck;
        end
        
        rake_1 = zeros(1,N);
        v = 1;
        for p = 1:N:N*N % N symbols se N diastimata
            
            col = [x(1,p:p+N-1)' ; zeros(L-1, 1)];
            row = [x(1,p) zeros(1,L-1)];
            X = toeplitz(col,row);
            
            wk = (var_w/2)*(randn(N+L-1,1) + 1i*randn(N+L-1,1));
            
            y = X*hk + wk;
            
            c = zeros(N+L-1,L);
            for o = 0:L-1
               c(:,o+1) = [zeros(o,1) ; ck' ; zeros(L-o-1,1)];
            end
            H = conj(hk)/norm(hk);
            
            ch = zeros(N+L-1,L);
            for o = 1:L
               ch(:,o) = H(o)*c(:,o); 
            end
            
            sums = zeros(1,L);
            for o = 1:L
               sums(1,o) = sum(ch(:,o).*y); 
            end
            
            rake_1(v) = sum(sums);
            v = v + 1;
            
        end
        
        berr = 0;
        for n = 1:N 
            if sign(s(n)) ~= sign(real(rake_1(n)))
                berr = berr + 1;
            end
        end
end

