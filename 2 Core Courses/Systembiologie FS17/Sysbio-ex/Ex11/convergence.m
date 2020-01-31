%PRE : Requires distance matrix and initial central centroids.
%POST: Returns number of iterations until convergence.

% still needs some work to get done.
function [counter] = convergence(dist, centroid, k, data)
    counter = 0;
    [~, centroid] = min(dist, [], 2);
    while 
    for i=1:k
        mean = mean(data(centroid == i,:),1);
        centroid(i) = mean;
    end