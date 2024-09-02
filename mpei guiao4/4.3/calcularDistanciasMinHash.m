function J = calcularDistanciasMinHash(Set, numHashFunctions)
    numUsuarios = length(Set);
    
    % Parâmetros do MinHash
    numHashFunctions = 200; % Número de funções de dispersão (pode ajustar)
    hashFunctions = gerarFuncoesHash(numHashFunctions);
    
    % Gera a matriz de assinaturas MinHash
    signatures = zeros(numHashFunctions, numUsuarios);
    for i = 1:numHashFunctions
        for j = 1:numUsuarios
            signatures(i, j) = min(hashFunctions{i}(Set{j}));
        end
    end
    
    % Calcula a distância de Jaccard a partir das assinaturas MinHash
    J = zeros(numUsuarios);
    for n1 = 1:numUsuarios
        for n2 = n1+1:numUsuarios
            intersection = sum(signatures(:, n1) == signatures(:, n2));
            union = numHashFunctions;
            J(n1, n2) = intersection / union;
            J(n2, n1) = J(n1, n2);
        end
    end
end