N = 100000;
p = 0.5;
nascimentos = rand(2, N);
rapazes = nascimentos < p;
n_rapazes = sum(rapazes);
A = n_rapazes >= 1;
B = n_rapazes == 2;
AB = A&B;
P_A_dado_B = sum(AB) / sum(A);
disp(P_A_dado_B)