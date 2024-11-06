function [berr] = Rake_kusers(N,K,L,c,var_w)
    
    h = zeros(L,K);
    for k = 1:K
        h(:,k) = sqrt(1/(2*L))*(randn(L,1) + 1i*randn(L,1)); 
    end

    s = sign(randn(K,N));

    x = zeros(K,N*N);
    for k = 1:K
        for n = 1:N
           x(k,((n-1)*N+1):(n*N)) = s(k,n).*c(k,:);
        end
    end

    rake_k = zeros(1,N);
    v = 1;
    for p = 1:N:N*N % N symbols se N diastimata
            
        y = zeros(N+L-1,1);
        for k = 1:K
            col = [x(k,p:p+N-1)' ; zeros(L-1, 1)];
            row = [x(k,p) zeros(1,L-1)];
            X = toeplitz(col,row);
                
            y = y + X*h(:,k);               
        end
        wk = (var_w/2)*(randn(N+L-1,1) + 1i*randn(N+L-1,1));
        y = y + wk;
            
        c_l = zeros(N+L-1,L);
        for o = 0:L-1
            c_l(:,o+1) = [zeros(o,1) ; c(1,:)' ; zeros(L-o-1,1)];
        end
        H = conj(h(:,1))/norm(h(:,1));
 
        ch = zeros(N+L-1,L);
        for o = 1:L
            ch(:,o) = H(o)*c_l(:,o); 
        end

        sums = zeros(1,L);
        for o = 1:L
            sums(1,o) = sum(ch(:,o).*y); 
        end

        rake_k(v) = sum(sums);
        v = v + 1;

    end
        
    berr = 0;
    for n = 1:N 
        if sign(s(1,n)) ~= sign(real(rake_k(n)))
            berr = berr + 1;
        end
    end
end

