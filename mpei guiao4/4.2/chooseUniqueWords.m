function U2 = chooseUniqueWords(wordlist, numWords, exclusionList)
    % Escolhe aleatoriamente numWords palavras diferentes de exclusionList
    wordIndices = randperm(length(wordlist), numWords);
    U2 = wordlist(wordIndices);

    % Garante que as palavras em U2 são diferentes de exclusionList
    while any(ismember(U2, exclusionList))
        wordIndices = randperm(length(wordlist), numWords);
        U2 = wordlist(wordIndices);
    end
end
