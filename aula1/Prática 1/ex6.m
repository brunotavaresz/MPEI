% a)

N = 1e6; %nr experiencias
p = 0.3;%prob de sair com defeito
k = 3;  %nr pecas defeitososas
n = 5;  %nr amostras

defeituoso = rand(n,N) < p;

defeitos = sum(defeituoso) == k;

probSimulacao = sum(defeitos)/N;
fprintf("ProbSimulacao -> %.10f \n", probSimulacao);

% b)

N = 1e6; %nr experiencias
p = 0.3;%prob de sair com defeito
k = 2;  %nr pecas defeitososas
n = 5;  %nr amostras

defeituoso = rand(n,N) < p;

defeitos = sum(defeituoso) <= k;

probSimulacao = sum(defeitos)/N;
fprintf("ProbSimulacao -> %.10f \n", probSimulacao);

% c)
N = 1e6; %nr experiencias
p = 0.3;%prob de sair com defeito

n = 5;  %nr amostras

for x = 0:n

    defeituoso = rand(n,N) < p;
    
    defeitos = sum(defeituoso) == x;
    
    %disp(defeitos)
    probSimulacao = sum(defeitos)/N;

    P(x+1) = probSimulacao;
    fprintf("ProbSimulacao -> %.10f \n", probSimulacao);
end

stem([0,1,2,3,4,5],P)