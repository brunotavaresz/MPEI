num_simulacoes = 100000;
contador = 0;

for i = 1:num_simulacoes
    nascimentos = randi([0, 1], 1, 5);
    
    if nascimentos(1) == 1
        if any(nascimentos(2:end) == 1)
            contador = contador + 1;
        end
    end
end

probabilidade = contador / num_simulacoes;
disp(probabilidade)
