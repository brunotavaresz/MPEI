function hashFunctions = gerarFuncoesHash(numHashFunctions)
    hashFunctions = cell(numHashFunctions, 1);
    for i = 1:numHashFunctions
        a = randi([1, 1000]);
        b = randi([1, 1000]);
        hashFunctions{i} = @(x) mod(a * x + b, 1000);
    end
end