clear
close all

% probability of error of BSC
bsc_pe = [1/20 1/10 1/8 1/6 1/5];

N = 128; % number of bits we send
loopTimes = 10^4; % total times to run the experiment

BER = zeros(1,length(bsc_pe));
i = 1;
% for every e we have run the code loopTimes to have a good estimate
for e = bsc_pe
    for k = 1:loopTimes
        BER(i) = BER(i) + BER_conv(N,e);
    end
    i = i+1;
end     
BER = BER/loopTimes; % normalise with the total loopTimes

figure()
% figure the e points with convolutional coding
loglog(bsc_pe,BER,'-*')  
hold on;
% figure the e points with simple transmission
loglog(bsc_pe,bsc_pe,'--square')  
hold off;
xlabel("Pr(e) BSC")
ylabel("BER")