function [A_corr_syn] = corr_syn(N,B,over,Ntr,Ar,train_symbols)
    corr = zeros(1,(4*B*over-1));
    corr_abs = zeros(1,(4*B*over-1));
    for d = 1:(4*B*over)

        Asample = Ar(d:over:Ntr*over+d-1);

        Asample_train = conj(train_symbols).*Asample;

        corr(d) = sum(Asample_train);
        corr_abs(d) = abs(corr(d));

    end

    figure()
    stem(1:(4*B*over), corr_abs)
    title("corrd abs")
    xlabel("d")

    d = find(corr_abs == max(corr_abs));

    A_corr_syn = Ar(d:over:N*over+d-1);
end

