clear all
close all

for Fs = [100 50]
    
    Wc = 0.5*pi;
    Fc = Wc/(2*pi);
    Ws = 2*pi*Fs;
    N1 = 21;
    N2 = 41;

    wc = Wc/(Ws/2);

    filter1 = fir1(N1-1, wc, hamming(N1));
    filter2 = fir1(N2-1, wc, hamming(N2));
    filter3 = fir1(N1-1, wc, hanning(N1));
    filter4 = fir1(N2-1, wc, hanning(N2));

    [H1, w1] = freqz(filter1,N1);
    [H2, w2] = freqz(filter2,N2);
    [H3, w3] = freqz(filter3,N1);
    [H4, w4] = freqz(filter4,N2);

    figure();
    subplot(1,2,1);
    plot(w1,abs(H1));
    xlabel("ω rad/sample");
    ylabel("|H(z)|");
    title("Hamming N = 21");
    subplot(1,2,2);
    plot(w2,abs(H2),'r');
    xlabel("ω rad/sample");
    ylabel("|H(z)|");
    title("Hamming N = 41");

    figure();
    subplot(1,2,1);
    plot(w3,abs(H3));
    xlabel("ω rad/sample");
    ylabel("|H(z)|");
    title("Hanning N = 21");
    subplot(1,2,2);
    plot(w4,abs(H4),'r');
    xlabel("ω rad/sample");
    ylabel("|H(z)|");
    title("Hanning N = 41");

    Kf = 500;
    n = 1:Kf;
    Ts = 1/Fs;
    x = sin(15*n*Ts) + 0.25*sin(200*n*Ts);

    X = fftshift(fft(x));
    f = -Fs/2:Fs/Kf:Fs/2-Fs/Kf;

    y1 = filter(filter1, 1, x);
    Y1 = fftshift(fft(y1));
    y2 = filter(filter2, 1, x);
    Y2 = fftshift(fft(y2));

    figure();
    subplot(3,1,1)
    stem(f, abs(X));
    xlabel("Frequency");
    ylabel("|X(f)|");
    title("Original signal");
    subplot(3,1,2)
    stem(f, abs(Y1));
    xlabel("Frequency");
    ylabel("|X(f)|");
    title("Hamming N = 21");
    subplot(3,1,3)
    stem(f, abs(Y2));
    xlabel("Frequency");
    ylabel("|X(f)|");
    title("Hamming N = 41");

    y3 = filter(filter3, 1, x);
    Y3 = fftshift(fft(y3));
    y4 = filter(filter4, 1, x);
    Y4 = fftshift(fft(y4));

    figure();
    subplot(3,1,1)
    stem(f, abs(X));
    xlabel("Frequency");
    ylabel("|X(f)|");
    title("Original signal");
    subplot(3,1,2)
    stem(f, abs(Y3));
    xlabel("Frequency");
    ylabel("|X(f)|");
    title("Hanning N = 21");
    subplot(3,1,3)
    stem(f, abs(Y4));
    xlabel("Frequency");
    ylabel("|X(f)|");
    title("Hanning N = 41");

end
