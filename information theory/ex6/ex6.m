clear
close all;
clc

p_error = 0.1; % probability of error of BSC
H_BSC = H(p_error); % entropy
C = 1 - H_BSC; % capacity of BSC
num_of_bin_codes = 1e5; % number of codebooks
rates = [1 1/2 1/3 1/4 1/5 1/8]; % rates to be processed
num_of_words = 10; % how many words we want to check

figure;
for R = rates  % for all rates

    N = 1/R : 1/R : 10/R; % length of codebook
    BER = zeros(1,length(N)); % initialize BER variable

    for i_n = 1:length(N)
        
        n = N(i_n);
        k = n*R; 
        
        % symbol dictionary
        symbol_dictionary = zeros(pow2(k),k);
        for i = 1:length(symbol_dictionary(:,1))
            symbol_dictionary(i,:) = dec2bin(i-1,k) - '0';
        end

        for bin_code = 1:num_of_bin_codes

            codebook = rand(2^k,n) < 0.5; % create codebook
            codewords_idx = randi(2^k,1,num_of_words); % create num_of_words different numbers (indexes)

            ber = 0;
            for word_number = 1:num_of_words
                
                c = codebook(codewords_idx(word_number),:); % code word to be transmitted
                received_word = bsc(c,p_error); % received word after BSC
                
                % vector of word transmited - same length as codebook
                rcv_word_vec = ones(length(codebook(:,1)),1)*received_word;
                % we have the number of '1' for every word in the codebook
                ml = sum(xor(codebook,rcv_word_vec),2);
                % find the first word with the min number of '1'
                idx = find(ml == min(ml),1);
                % detected word
                detected_word = symbol_dictionary(idx,:);
                transmitted_word = symbol_dictionary(codewords_idx(word_number),:);
                                
                % ber for every word
                ber = ber + sum(xor(transmitted_word,detected_word));
            end
            BER(i_n) = BER(i_n) + ber/10;
        end
        BER(i_n) = BER(i_n)/(num_of_bin_codes*k);
    end
    semilogy(N, BER);
    hold on;
end
grid on;
xlabel('n');
ylabel('BER');
title('Bit-Error Rate (BER) of Binary Symmetric Channel (BSC)');
legend('R = 1','R = 1/2','R = 1/3','R = 1/4','R = 1/5','R = 1/8');