figure 
fimplicit(@(x1,x2) x1+x2-1, [0 1.2 0 1.2])
hold on; grid on; axis equal
fimplicit(@(x1,x2) x1^2+x2^2-1 , [0 1.2 0 1.2])
fill([0 1 0], [1 0 0], 'cyan')
xlabel("x1"); ylabel("x2"); title("Scheme for the problem")
