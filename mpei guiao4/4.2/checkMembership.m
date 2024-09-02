function isMember = checkMembership(bloomFilter, element, k)
    isMember = true;
    for i = 1:k
        index = hashFunction(element, i, length(bloomFilter));
        if bloomFilter(index) == 0
            isMember = false;
            break;
        end
    end
end