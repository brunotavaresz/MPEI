function Set = criarEstruturaConjuntos(u, numUsuarios)
    % Seleciona aleatoriamente numUsuarios usuários
    usuariosAleatorios = randperm(max(u(:, 1)), numUsuarios);
    
    Set = cell(numUsuarios, 1);
    for i = 1:numUsuarios
        ind = (u(:, 1) == usuariosAleatorios(i));
        Set{i} = unique([Set{i}; u(ind, 2)]);
    end
end
