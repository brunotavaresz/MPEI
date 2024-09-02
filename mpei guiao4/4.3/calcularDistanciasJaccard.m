function J = calcularDistanciasJaccard(Set)
    numUsuarios = length(Set);

    J = zeros(numUsuarios);
    for n1 = 1:numUsuarios
        set1 = ismember(1:max(cellfun(@max, Set)), Set{n1});
        for n2 = n1+1:numUsuarios
            set2 = ismember(1:max(cellfun(@max, Set)), Set{n2});
            intersection = sum(set1 & set2);
            union = sum(set1 | set2);
            J(n1, n2) = intersection / union;
            J(n2, n1) = J(n1, n2);
        end
    end
end
