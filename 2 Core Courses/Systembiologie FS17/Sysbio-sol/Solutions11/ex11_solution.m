clc
clear
close all
load ex11

%% Question 1.7
figure;
scatter(data(:,1), data(:,2), [], true_labels);
title('true labels');
print -dpng scatter_true

%% Question 1.1-1.6
rng(2015);
figure;
scatter(data(:,1), data(:,2), [], mykmeans(data, 3));
title('k = 3, mykmeans, seed = 2015');
print -dpng scatter1

%% Question 1.8
rng(2015);
figure;
scatter(data(:,1), data(:,2), [], mykmeans(data, 5));
title('k = 5, mykmeans, seed = 2015');
print -dpng scatter2

%% Question 1.9
rng(2016);
figure;
scatter(data(:,1), data(:,2), [], mykmeans(data, 5));
title('k = 5, mykmeans, seed = 2016');
print -dpng scatter3

%% Question 1.10
figure;
scatter(data(:,1), data(:,2), [], kmeans(data, 3));
title('k = 3, using kmeans');
print -dpng scatter4

%% Question 2.1
load ex9
ex_data = [expression.strain02, expression.strain03, expression.strain06, expression.strain08]';
rng(2015);
idx = kmeans(ex_data, 4);
disp(['kmeans cluster indices:  ' num2str(idx')]);

%% Question 2.2
Z = linkage(ex_data, 'average');
dendrogram(Z);
print -dpng dendrogram

