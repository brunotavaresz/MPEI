function hashCodes = hashFunctionTest(keys, seed, filterSize)
    rng(seed); 
    numKeys = length(keys);
    hashCodes = zeros(1, numKeys);

    for i = 1:numKeys
        hash = mod(hashString(keys{i}), filterSize) + 1;
        hashCodes(i) = hash;
    end
end
