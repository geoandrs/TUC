function [OFDM_err] = BER_OFDM_Diversity(K,N,L,D,SNRdB)

    total_BER = zeros(1, length(SNRdB));
    v = 1;
    for tmpSNRdB = SNRdB

        for k = 1:D*K

            h = sqrt(1/(2*L))*(randn(1,L) + 1i*randn(1,L));
            d_t = bits_to_4QAM(N/D);

            d_tilda = [];
            for u = 1:D
                d_tilda = [d_tilda d_t];
            end

            d = sqrt(N)*ifft(d_tilda);

            No = 2/db2mag(tmpSNRdB);
            wf = (No/2)*(randn(1,N) + 1i*randn(1,N));

            x = [d(N-L+2:N),d];
            y = conv(h,x);
            ym = y(L:N+L-1) + wf;
            y_tilda = (1/sqrt(N))*fft(ym);
            h_tilda = (1/sqrt(N))*fft(h,N);

            h_mrc = [];
            y_mrc = [];
            for u = 1:D
                st = (u-1)*N/D+1;
                e = st+N/D-1;
                h_mrc = [h_mrc ; h_tilda(st:e);];
                y_mrc = [y_mrc ; y_tilda(st:e)];
            end        

            err = 0;
            for m = 1:N/D
                hc = (1/norm(h_tilda))*conj(h_mrc(:,m)).';
                err = err + find_errors_bits(d_tilda(m), hc*y_mrc(:,m));
            end

            total_BER(v) = total_BER(v) + err;

        end
        v = v + 1;
    end
    OFDM_err = total_BER/(2*K*N);
    
end

