function hash = hashString(str)
    hash = 0;
    for i = 1:length(str)
        hash = mod(hash * 31 + double(str(i)), 2^32);
    end
end