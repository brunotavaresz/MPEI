N = 100000;
p = 0.5;
nascimentos = rand(2, N);
rapazes = nascimentos < p;
n_rapazes = sum(rapazes);
A = rapazes(2, :) == 1;
B = rapazes(1, :) == 1;
AB = A&B;
P_A_dado_B = sum(AB) / sum(A);
disp(P_A_dado_B)