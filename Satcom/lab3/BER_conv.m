function [BER] = BER_conv(N,e)
    
    m = (randn(N,1)>0); % bits to send

    % convolutional code
    b = zeros(2*N-1,1);
    for i = 1:N-1
        b(2*i) = xor(m(i),m(i+1));
        b(2*i-1) = m(i);
    end
    b(2*N-1) = m(N);

    y = bsc(b,e); % BSC channel

    we = log((1-e)/e); % weight for BSC

    trellis = zeros(2,4,N); % vector to store weights and choices

    %% forward pass
    % calculate weight for every state
    % use the form of Trellis of the notes to write down
    % the following equations
    w1 = (y(1)==0)*we+(y(2)==0)*we;
    w2 = (y(1)==0)*we+(y(2)==1)*we;
    w3 = (y(1)==1)*we+(y(2)==1)*we;
    w4 = (y(1)==1)*we+(y(2)==0)*we;
    w = [w1 w2 w3 w4];
    trellis(1,:,1) = w;   
    for i = 2:N-1

        % calculate weight for every step
        w1 = (y(2*i-1)==0)*we+(y(2*i)==0)*we;
        w2 = (y(2*i-1)==0)*we+(y(2*i)==1)*we;
        w3 = (y(2*i-1)==1)*we+(y(2*i)==1)*we;
        w4 = (y(2*i-1)==1)*we+(y(2*i)==0)*we;
        
        % calculate total weight for every state
        w1_tot = w1+max(trellis(1,1,i-1),trellis(1,3,i-1));
        w2_tot = w2+max(trellis(1,1,i-1),trellis(1,3,i-1));
        w3_tot = w3+max(trellis(1,2,i-1),trellis(1,4,i-1));
        w4_tot = w4+max(trellis(1,2,i-1),trellis(1,4,i-1));
        w = [w1_tot w2_tot w3_tot w4_tot];
        trellis(1,:,i) = w;

        % find the previous state based on weights of every state
        if w1_tot == w1+trellis(1,1,i-1)
            prev1 = 1;
        else
            prev1 = 3;
        end
        if w2_tot == w2+trellis(1,1,i-1)
            prev2 = 1;
        else
            prev2 = 3;
        end
        if w3_tot == w3+trellis(1,2,i-1)
            prev3 = 2;
        else 
            prev3 = 4;
        end
        if w4_tot == w4+trellis(1,2,i-1)
            prev4 = 2;
        else
            prev4 = 4;
        end
        prev = [prev1 prev2 prev3 prev4];
        trellis(2,:,i) = prev;

    end
    % do the same for the last bit
    wN0 = (y(2*N-1)==0)*we;
    wN1 = (y(2*N-1)==1)*we;

    wN0_tot = wN0+max(trellis(1,1,N-1),trellis(1,3,N-1));
    wN1_tot = wN1+max(trellis(1,2,N-1),trellis(1,4,N-1));
    w = [wN0_tot 0 wN1_tot 0];
    trellis(1,:,N) = w;

    if wN0_tot == wN0+trellis(1,1,N-1)
        prevN0 = 1;
    else
        prevN0 = 3;
    end
    if wN1_tot == wN1+trellis(1,2,N-1)
        prevN1 = 2;
    else
        prevN1 = 4;
    end
    prev = [prevN0 0 prevN1 0];
    trellis(2,:,N) = prev;

    %% backtrace
    % find the position with the max weight
    % this is the last bit we sent
    pos = find(max(trellis(1,:,N))==trellis(1,:,N));
    detected = zeros(1,N);
    for i = N:-1:1 
        % use Trellis form to decrease the if else conditions
        if pos == 1 | pos == 2
            detected(i) = 0;
        else
            detected(i) = 1;        
        end
        pos = trellis(2,pos,i); % move backward until first position
    end
    %% BER
    BER = 0;
    for i = 1:N
        % find all the wrong bits and the normalise
        if detected(i) ~= m(i)
            BER = BER + 1;
        end
    end
    BER = BER/N;
end

