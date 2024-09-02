turistas1 = load("turistas1.data");
turistas = turistas1(:, [1, 2, 4]); % descarta a 3ª coluna 

users = unique(turistas(:,1)); 
numUsers= length(users); % número de clientes


rest = readcell('restaurantes.txt', 'Delimiter', '\t');
numRest = height(rest); % número de restaurantes

restaurants = getRestaurants(users, turistas, numUsers);
numHash = 100;
usersMinHash = minHashUsers(users,numHash,restaurants);
distancesUsers = getDistancesMinHashUsers(numUsers,usersMinHash,numHash);


restNames = rest(:,2);
shingleSize = 3;
restMinHash = minHashRest(restNames, numHash, shingleSize);
distancesRest = getDistancesRest(numRest,restMinHash, numHash);

filterSize = 1000;
filtro = inicializarFiltro(filterSize);
restaurantIDs = cellstr(num2str(cell2mat(rest(:, 1))));

numRestaurantIDs = length(restaurantIDs);
uniqueRestaurantIDs = unique(restaurantIDs);
numUniqueRestaurantIDs = length(uniqueRestaurantIDs);

numHashFunc = round(filterSize * log(2) / numUniqueRestaurantIDs);

function restaurants = getRestaurants(users, turistas, numUsers)
        restaurants = cell(numUsers, 1);
        
        % ciclo que itera em todos os clientes
        for n = 1:numUsers
            ind = turistas(:, 1) == users(n); % Seleciona os indices iguais ao do cliente atual
            restaurants{n} = turistas(ind, 2); % Atribui os restaurantes ao cliente
        end
end

function matrizMinHashUsers = minHashUsers(users,numHash,restaurants)
    numUsers = length(users);
    matrizMinHashUsers = inf(numUsers, numHash);
    
    x = waitbar(0,'A calcular minHashUsers()...');
    for k= 1 : numUsers
        waitbar(k/numUsers,x);
        restUser = restaurants{k};
        for j = 1:length(restUser)
            seed = char(restUser(j));
            for i = 1:numHash
                seed = [seed num2str(i)];
                h(i) = DJB31MA(seed, 127);
            end
            matrizMinHashUsers(k, :) = min([matrizMinHashUsers(k, :); h]);
        end
    end
    delete(x);
end

function distances = getDistancesMinHashUsers(numUsers,matrizMinHash,numHash) 
    distances = zeros(numUsers,numUsers);
    for n1= 1:numUsers
        for n2= n1+1:numUsers
            distances(n1,n2) = sum(matrizMinHash(n1,:)==matrizMinHash(n2,:))/numHash;
        end
    end
end

function MinHashRest = minHashRest(restList, numHash, shingleSize)
    numRest = length(restList);
    MinHashRest = inf(numRest, numHash);
    
    x = waitbar(0, 'A calcular minHashTitles()...');
    for k = 1:numRest
        waitbar(k/numRest, x);
        rest = restList{k};
        for j = 1:(length(rest) - shingleSize + 1)
            shingle = lower(char(rest(j:(j+shingleSize-1))));
            h = zeros(1, numHash);
            for i = 1:numHash
                shingle = [shingle num2str(i)];
                h(i) = DJB31MA(shingle, 127);
            end
            MinHashRest(k, :) = min([MinHashRest(k, :); h]);
        end
    end
    delete(x);
end
    

function distancesRest = getDistancesRest(numRest, MinHashRest, numHash) 
    distancesRest = zeros(numRest,numRest);
    for n1= 1:numRest
        for n2= n1+1:numRest
            distancesRest(n1,n2) = sum(MinHashRest(n1,:)==MinHashRest(n2,:))/numHash;
        end
    end
end

function filtro = inicializarFiltro(n)
    filtro = zeros(n, 1);
end

function filtro = adicionarElemento(filtro, chave, numHashFunc, tablesize)
    for i = 1:numHashFunc
        chave1 = [chave num2str(i)];
        code = mod(DJB31MA(chave1, 127), tablesize) + 1;
        filtro(code) = filtro(code) + 1;
    end
end

function resultado = pertenceConjunto(filtro, chave, numHashFunc, tablesize)
    res = zeros(numHashFunc, 1);
    for i = 1:numHashFunc
        chave1 = [chave num2str(i)];
        code = mod(DJB31MA(chave1, 127), tablesize) + 1;
        res(i) = filtro(code);
    end
    resultado = sum(res);
end

function h= DJB31MA( chave, seed)
    len= length(chave);
    chave= double(chave);
    h= seed;
    for i=1:len
        h = mod(31 * h + chave(i), 2^32 -1) ;
    end
end






