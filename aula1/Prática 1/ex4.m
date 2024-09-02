prob = zeros(1,20);

for x = 0:20
    prob(x+1) = probalidade(0.5,20,x,1e5);
end

stem(prob)