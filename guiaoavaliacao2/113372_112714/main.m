user_id = 0;
filterSize = 1000;
filtro = inicializarFiltro(filterSize);
while(user_id<1 || user_id>836)
    user_id = input('Insert User ID (1 to 836): ');
    if (user_id<1 || user_id>836)
        fprintf("ERROR: Enter a valid ID User\n");
    end
end


clear menu;
menu = menu('Restaurants guide ', ...
    '1 - Restaurants evaluated by you', ...
    '2 - Set of restaurants evaluated by the most similar user', ...
    '3 - Search restaurant', ...
    '4 - Find most similar restaurants', ...
    '5 - Estimate the number of evaluations for each restaurant', ...
    '6 - Exit');

while(menu ~= 6 && menu ~= 0)
    switch menu
        case 1
            user_restaurants = sort(restaurants{user_id});
            if isempty(user_restaurants)
                fprintf('This user has not evaluated any restaurant.\n');
            else
                fprintf('Evaluated restaurants by user ID=%d\n', user_id)
                fprintf('ID\t|\tRestaurant Name\t|\tDistrict\n');
                for i = 1:length(user_restaurants)
                    restID = user_restaurants(i);
                    restInfo = rest(restID, [1, 2, 4]);
                    fprintf('%s\t|\t%s\t|\t%s\n', num2str(restID), char(restInfo{2}), char(restInfo{3}));
                end
            end
            clear user_restaurants;
            clear restInfo;
            clear restID;
            fprintf('\n');
        case 2
            max_similarity = 0;
            most_similar_user_id = 0;
            
            for other_user_id = 1:numUsers
                if other_user_id == user_id
                    continue;
                end
            
                user_restaurants = sort(restaurants{user_id});
                other_user_restaurants = sort(restaurants{other_user_id});
            
                intersection = intersect(user_restaurants, other_user_restaurants);
                union_set = union(user_restaurants, other_user_restaurants);
                similarity = length(intersection) / length(union_set);
            
                if similarity > max_similarity
                    max_similarity = similarity;
                    most_similar_user_id = other_user_id;
                end
            end
            
            if most_similar_user_id > 0
                most_similar_user_restaurants = sort(restaurants{most_similar_user_id});
                fprintf("Evaluated retaurants by the most similar user to ID=%d\n", user_id)
                fprintf('ID\t|\tRestaurant Name\t|\tDistrict\n');
                for i = 1:length(most_similar_user_restaurants)
                    restID = most_similar_user_restaurants(i);
                    restInfo = rest(restID, [1, 2, 4]);
                    fprintf('%s\t|\t%s\t|\t%s\n', num2str(restID), char(restInfo{2}), char(restInfo{3}));
                end
            else
                fprintf('No more similar user found.\n');
            end

        case 3
            parameter = lower(input('Write a string: ', 's'));
            while (length(parameter) < shingleSize)
                fprintf('Write a minimum of %d characters\n', shingleSize);
                parameter = lower(input('Write a string: ', 's'));
            end
            searchRest(parameter, restMinHash, numHash, restNames, shingleSize)
            fprintf('\n');
            clear parameter;
            fprintf('\n');

        case 4
            user_restaurants = sort(restaurants{user_id});
            if isempty(user_restaurants)
                fprintf('This user has not evaluated any restaurant.\n');
            else
                fprintf('Evaluated restaurants by user ID=%d\n', user_id)
                fprintf('ID\t|\tRestaurant Name\t|\tDistrict\n');
                for i = 1:length(user_restaurants)
                    restID = user_restaurants(i);
                    restInfo = rest(restID, [1, 2, 4]);
                    fprintf('%s\t|\t%s\t|\t%s\n', num2str(restID), char(restInfo{2}), char(restInfo{3}));
                end
                fprintf('\n');
                verifier = 0;
                while verifier == 0
                    chosenRestID = input("Enter the ID of the chosen restaurant: ", "s");
                    chosenRestID = str2double(chosenRestID);
                    for i = 1:length(user_restaurants)
                        restID = user_restaurants(i);
                        if chosenRestID == restID
                            verifier = 1;
                            restInfo = rest(restID, [1, 2, 4]);
                            break;
                        end
                    end
                    if verifier == 0
                        fprintf("ERROR: Enter a valid restaurant ID\n");
                    end
                end
            end
            fprintf('Chosen restaurant:\n%s\t|\t%s\t|\t%s\n', num2str(restID), char(restInfo{2}), char(restInfo{3}));
            getTopSimilarRestaurants(rest, restInfo, restNames, restMinHash, numHash, shingleSize);
            
            clear user_restaurants;
            clear restInfo;
            clear restID;
            clear verifier;
            clear chosenRestID;
            clear restaurantName;
            clear nameIndex;
            clear selectedRestMinHash;
            clear similarRest;
            clear distances;
            fprintf('\n');
        
        case 5
            restaurantID = 0;
            while(restaurantID <= 0 || restaurantID > 213)
                restaurantID = input('Enter Restaurant ID: ');
                if (restaurantID < 1 || restaurantID > 213)
                    fprintf("ERROR: Enter a valid Restaurant ID\n");
                end
            end

            restaurantIDStr = num2str(restaurantID);
            totalAvaliacoes = 0;
            for userID = 1:numUsers
                user_restaurants = sort(restaurants{userID});
                if ismember(restaurantID, user_restaurants)
                    filtro = adicionarElemento(filtro, restaurantIDStr, numHashFunc, filterSize);
                    totalAvaliacoes = totalAvaliacoes + 1;
                end
            end

            fprintf("Total number of reviews for Restaurant ID %d: %d\n", restaurantID, totalAvaliacoes);

    end
    clear menu;
    menu = menu('Restaurants guide', ...
        '1 - Restaurants evaluated by you', ...
        '2 - Set of restaurants evaluated by the most similar user', ...
        '3 - Search restaurant', ...
        '4 - Find most similar restaurants', ...
        '5 - Estimate the number of evaluations for each restaurant', ...
        '6 - Exit');
end

function searchRest(parameter, restMinHash, numHash, restaurants, shingleSize)
    minHashSearch = inf(1, numHash);
    for j = 1 : (length(parameter) - shingleSize + 1)
        shingle = char(parameter(j:(j+shingleSize-1))); 
        h = zeros(1, numHash);
        for i = 1 : numHash
            shingle = [shingle num2str(i)];
            h(i) = DJB31MA(shingle, 127);
        end
        minHashSearch(1, :) = min([minHashSearch(1, :); h]);
    end

    threshold = 0.99;
    [similarTitles,distancesRest,k] = filterSimilar(threshold,restaurants,restMinHash,minHashSearch,numHash);

    if (k == 0)
        disp('No results found');
    elseif (k > 5)
        k = 5;
        fprintf('Most similar titles to "%s":\n', parameter);
    end

    distances = cell2mat(distancesRest);
    [distances, index] = sort(distances);

    for h = 1 : k
        fprintf('%s - Distance: %.3f\n', similarTitles{index(h)}, distances(h));
    end
end

function h= DJB31MA( chave, seed)
    len= length(chave);
    chave= double(chave);
    h= seed;
    for i=1:len
        h = mod(31 * h + chave(i), 2^32 -1) ;
    end
end


function [similarRest,restDistances,k] = filterSimilar(threshold,restaurants,restMinHash,minHash_search,numHash)
    similarRest = {};
    restDistances = {};
    numTitles = length(restaurants);
    k=0;
    for n = 1 : numTitles
        distancia = 1 - (sum(minHash_search(1, :) == restMinHash(n,:)) / numHash);
        if (distancia < threshold)
            k = k+1;
            similarRest{k} = restaurants{n};
            restDistances{k} = distancia;
        end
    end
end

function getTopSimilarRestaurants(rest, chosenRestInfo, restNames, restMinHash, numHash, ~)
    restaurantName = char(chosenRestInfo{2});
    nameIndex = find(strcmp(restNames, restaurantName));
    
    if ~isempty(nameIndex)
        selectedRestMinHash = restMinHash(nameIndex, :);

        [similarRest, distances, ~] = filterSimilar(0.99, restNames, restMinHash, selectedRestMinHash, numHash);

        chosenIndex = find(strcmp(similarRest, restaurantName));
        if ~isempty(chosenIndex)
            similarRest(chosenIndex) = [];
            distances(chosenIndex) = [];
        end

        [~, idx] = sortrows([distances']);

        fprintf('\nThe 3 most similar restaurants:\n');
        fprintf('ID\t|\tRestaurant Name\t|\tDistrict\n');
        for k = 1:min(3, length(similarRest))
            similarRestInfo = rest(strcmp(rest(:, 2), similarRest{idx(k)}), [1, 2, 4]);
            fprintf('%s\t|\t%s\t|\t%s\n', num2str(similarRestInfo{1}), char(similarRestInfo{2}), char(similarRestInfo{3}) );
        end
    else
        error('Restaurant name not found.');
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
