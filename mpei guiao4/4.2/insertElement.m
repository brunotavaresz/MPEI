function bloomFilter = insertElement(bloomFilter, element, k)
    for i = 1:k
        index = hashFunction(element, i, length(bloomFilter));
        bloomFilter(index) = 1;
    end
end
