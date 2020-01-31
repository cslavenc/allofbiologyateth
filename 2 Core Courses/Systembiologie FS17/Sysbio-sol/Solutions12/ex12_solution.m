clear all;
close all;
load ex12;
rng(2016);

%%
DataALL = expression(:, true_labels==1);
DataAML = expression(:, true_labels==2);
log2FC = mean(DataALL, 2) - mean(DataAML, 2);
PValues = mattest(DataALL, DataAML, 'VarType', 'equal');
[~, QValues] = mafdr(PValues);
I = find(QValues < 0.001 & abs(log2FC) > 2);
log2FC = mean(DataALL, 2) - mean(DataAML, 2);
[~, i1] = max(-log10(QValues) .* (log2FC > 2));
[~, i2] = max(-log10(QValues) .* (log2FC < -2));

%mavolcanoplot(DataALL, DataAML, QValues, 'Labels', genes, 'PCUTOFF', 0.05, 'FOLDCHANGE', 4.0);

%% Question 1.2 - using the two most significant genes
hFig = figure;
set(gcf, 'PaperPositionMode', 'auto');
set(hFig, 'Position', [0 0 800 1000]);
set(gca, 'DefaultTextFontSize', 8);
set(gca, 'FontSize', 8);

gene1 = genes{i1};
gene2 = genes{i2};
I1 = find(ismember(genes, gene1));
I2 = find(ismember(genes, gene2));

Y1 = expression([I1 I2], :);
subplot(3, 2, 1);
plot(Y1(1,true_labels==1), Y1(2,true_labels==1), 'og');
hold on;
plot(Y1(1,true_labels==2), Y1(2,true_labels==2), 'or');
legend({'ALL', 'AML'}, 'FontSize', 8, 'Location', 'best');
xlabel(['Up regulated gene with lowest p-value: ', gene1], 'FontSize', 8, 'Interpreter', 'none');
ylabel(['Down regulated gene with lowest p-value: ', gene2], 'FontSize', 8, 'Interpreter', 'none');

%% Question 1.3 - k-means using 2 genes

subplot(3, 2, 2);
clusters1 = kmeans(Y1', 2);
title(sprintf('PCA using %d most significant genes, true labels', length(I)));
plot(Y1(1,clusters1==1), Y1(2,clusters1==1), 'oc');
hold on;
plot(Y1(1,clusters1==2), Y1(2,clusters1==2), 'om');
xlabel(['Up regulated gene with lowest p-value: ', gene1], 'FontSize', 8, 'Interpreter', 'none');
ylabel(['Down regulated gene with lowest p-value: ', gene2], 'FontSize', 8, 'Interpreter', 'none');

%% Question 1.4 - using the two principal components among all genes
Y2 = pca(expression', 'NumComponents', 2)' * expression;
subplot(3, 2, 3);
plot(Y2(1,true_labels==1), Y2(2,true_labels==1), 'og');
hold on;
plot(Y2(1,true_labels==2), Y2(2,true_labels==2), 'or');
legend({'ALL', 'AML'}, 'FontSize', 8, 'Location', 'best');
xlabel('PC1', 'FontSize', 8);
ylabel('PC2', 'FontSize', 8);

%% Question 1.5 - k-means using the two principal components among all genes
subplot(3, 2, 4);
clusters2 = kmeans(Y2', 2);
plot(Y2(1,clusters2==1), Y2(2,clusters2==1), 'oc');
hold on;
plot(Y2(1,clusters2==2), Y2(2,clusters2==2), 'om');
xlabel('PC1', 'FontSize', 8);
ylabel('PC2', 'FontSize', 8);

%% Question 1.6 - using the two principal components among only the significant genes
Y3 = pca(expression(I,:)', 'NumComponents', 2)' * expression(I,:);
subplot(3, 2, 5);
plot(Y3(1,true_labels==1), Y3(2,true_labels==1), 'og');
hold on;
plot(Y3(1,true_labels==2), Y3(2,true_labels==2), 'or');
legend({'ALL', 'AML'}, 'FontSize', 8, 'Location', 'best');
xlabel(sprintf('PC1 (over %d significant genes)', length(I)), 'FontSize', 8);
ylabel(sprintf('PC2 (over %d significant genes)', length(I)), 'FontSize', 8);

%% Question 1.5 - k-means using the two principal components among only the significant genes
subplot(3, 2, 6);
clusters3 = kmeans(Y3', 2);
plot(Y3(1,clusters3==1), Y3(2,clusters3==1), 'oc');
hold on;
plot(Y3(1,clusters3==2), Y3(2,clusters3==2), 'om');
xlabel(sprintf('PC1 (over %d significant genes)', length(I)), 'FontSize', 8);
ylabel(sprintf('PC2 (over %d significant genes)', length(I)), 'FontSize', 8);

print -dpdf scatter_plots
