function idx = mykmeans(data, k)
N = size(data, 1);

init_ind = randperm(N, k); 
centroids = data(init_ind, :);

% a vector containing the previous iteration's cluster indices
% that will be used to check if the algorithm has converged.
previous_idx = zeros(N, 1);

iter = 1;
while true
    distances = pdist2(data, centroids, 'euclidean'); 
    [~, new_idx] = min(distances, [], 2); 

    if all(previous_idx == new_idx)
        % cluster indices are the same as in the previous iteration -> convergence
        break; 
    else
        previous_idx = new_idx;
    end

    for j = 1:k
        centroids(j, :) = mean(data(new_idx==j, :), 1); 
    end

    iter = iter + 1;
end
fprintf('kmeans converged after %d iterations\n', iter)
idx = new_idx;