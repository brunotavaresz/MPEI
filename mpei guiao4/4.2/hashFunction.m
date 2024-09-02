function index = hashFunction(element, seed, filterSize)
    hashCodes = hashFunctionTest({element}, seed, filterSize);
    index = hashCodes(1);
end
