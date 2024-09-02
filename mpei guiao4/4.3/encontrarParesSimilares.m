function SimilarUsers = encontrarParesSimilares(J, Set, threshold)
    numUsuarios = length(Set);
    
    maxSimilarUsers = nchoosek(numUsuarios, 2);
    SimilarUsers = zeros(maxSimilarUsers, 3);
    k = 1;
    
    for n1 = 1:numUsuarios
        set1 = ismember(1:max(cellfun(@max, Set)), Set{n1});
        for n2 = n1+1:numUsuarios
            if J(n1, n2) < threshold
                set2 = ismember(1:max(cellfun(@max, Set)), Set{n2});
                SimilarUsers(k, :) = [n1 n2 J(n1, n2)];
                k = k + 1;
            end
        end
    end
    
    SimilarUsers = SimilarUsers(1:k-1, :); % Remover linhas não utilizadas
end
