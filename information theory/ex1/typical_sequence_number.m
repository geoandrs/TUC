function [H_x, lb, ub, typical_sequence_number] = typical_sequence_number(epsilon,n_values,p_values)
figure; 
i_p = 1;
typical_sequence_number = zeros(length(p_values),length(n_values));
for p=p_values
    H_x(i_p) = -p*log2(p) - (1-p)*log2(1-p); % entropy
    lb(i_p) = H_x(i_p)-epsilon;
    ub(i_p) = H_x(i_p)+epsilon;
    lbound = (1-epsilon)*2.^(n_values*lb(i_p)); % min number of typical sequences
    ubound = 2.^(n_values*ub(i_p)); % max number of typical sequences
    for i_n = n_values
        prob_ubound = 2^(-i_n*lb(i_p));
        prob_lbound = 2^(-i_n*ub(i_p));
    
        k = 0:i_n;
        seq_prob = (p.^k).*(1-p).^(i_n-k); % probability of sequence
        idx = find(seq_prob >= prob_lbound & seq_prob <= prob_ubound);
        for i_idx = idx
            typical_sequence_number(i_p,i_n/10) = typical_sequence_number(i_p,i_n/10) + nchoosek(i_n,i_idx-1);
        end
    end
    semilogy(n_values,typical_sequence_number(i_p,:),'Color','r');
    hold on;
    grid on;
    semilogy(n_values,2.^n_values,'--','Color','k');
    semilogy(n_values,lbound,'Color','g');
    semilogy(n_values,ubound,'Color','b');

    i_p = i_p+1;
end
end

