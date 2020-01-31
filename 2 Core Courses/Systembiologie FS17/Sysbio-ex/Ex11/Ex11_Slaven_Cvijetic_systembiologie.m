% Exercise 11 - Systems Biology
% Slaven Cvijetic

load ex11

%% PART 1 - Implementation of k-means using Lloyd's method

% PART 1.1
rng(2015);
N = 300;
k = 3;
perm_1 = randperm(N,k);
perm_2 = randperm(N,k);
perm = [perm_1; perm_2].';

% PART 1.2
D = pdist2(data, perm, 'euclidean');    %not quite correct - doesnt work

% PART 1.3
[~, closest_centroid] = min(D, [], 2);

% PART 1.4

for i=1:k
    mean = mean(data(closest_centroid == i,:),1);
    closest_centroid(i) = mean;
end

% PART 1.5
scatter(data(:,1), data(:,2), [], closest_centroid);

% PART 1.6
counter = 0;
counter = convergence(INPUT);

% PART 1.7

