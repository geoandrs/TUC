function [A_energy_syn] = energy_syn(Ar,over,N,B)
    en = zeros(1,(4*B*over-1));
    for d = 1:(4*B*over)

        Asample = Ar(d:over:N*over+d-1);

        Asample_abs = (abs(Asample)).^2;

        en(d) = sum(Asample_abs);

    end

    d = find(en == max(en));
    
    figure()
    stem(1:length(en),en)
    title("Energy of every sequence based on d")
    xlabel("d")
    grid on;
    
    A_energy_syn = Ar(d:over:N*over+d-1);

end

