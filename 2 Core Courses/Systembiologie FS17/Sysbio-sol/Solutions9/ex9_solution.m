clc
clear
close all
load ex9

s1 = '01';
s2 = '04';
s3 = '02';

g1 = 'dinI';
g2 = 'rydC';

DataX = eval(['expression.strain' s1]);
DataY = eval(['expression.strain' s2]);

%% Question 1.1-1.3
% plot a histogram of the mean expression per gene
figure(1);
subplot(2, 1, 1);
hist(mean(DataX, 2), 50);
title('strain01');
xlabel('mean(log_2 expr.)');
ylabel('#genes');

% plot a histogram of the standard deviations per gene
subplot(2, 1, 2);
sigma01 = std(DataX, 0, 2);
hist(sigma01, 50);
xlabel('std(log_2 expr.)');
ylabel('#genes');
print -dpdf histograms

ind = find(sigma01 > 0.6);
fprintf('%d genes with standard deviation > 1: %s\n', length(ind), ...
        strjoin(genes(ind)', ','));

%% Question 1.4

ind_g1 = find(strcmp(genes, g1));
ind_g2 = find(strcmp(genes, g2));

mu_X1 = mean(DataX(ind_g1, :));
sigma_X1 = std(DataX(ind_g1, :));
mu_X2 = mean(DataX(ind_g2, :));
sigma_X2 = std(DataX(ind_g2, :));

mu_Y1 = mean(DataY(ind_g1, :));
sigma_Y1 = std(DataY(ind_g1, :));
mu_Y2 = mean(DataY(ind_g2, :));
sigma_Y2 = std(DataY(ind_g2, :));

means = [mu_X1, mu_X2; mu_Y1, mu_Y2];
stds = [sigma_X1, sigma_X2; sigma_Y1, sigma_Y2];

foldchange_g1 = 2^(mu_X1 - mu_Y1);
foldchange_g2 = 2^(mu_X2 - mu_Y2);

% unpaired two sample t-test for gene dinI between the dinI and luc strains
tstat_g1 = abs(mu_X1 - mu_Y1)/sqrt((sigma_X1^2 + sigma_Y1^2)/3);
pvalue_g1 = 2*(1-tcdf(tstat_g1, 4));

% unpaired two sample t-test for gene rydC between the dinI and luc strains
tstat_g2 = abs(mu_X2 - mu_Y2)/sqrt((sigma_X2^2 + sigma_Y2^2)/3);
pvalue_g2 = 2*(1-tcdf(tstat_g2, 4));

fprintf('Mean log2 expression of gene %s in strain%s: %.2f\n', g1, s1, mu_X1);
fprintf('Mean log2 expression of gene %s in strain%s: %.2f\n', g1, s2, mu_Y1);
fprintf('Mean log2 expression of gene %s in strain%s: %.2f\n', g2, s1, mu_X2);
fprintf('Mean log2 expression of gene %s in strain%s: %.2f\n', g2, s2, mu_Y2);

fprintf('Standard deviation of log2 expression of gene %s in strain%s: %.2f\n', g1, s1, sigma_X1);
fprintf('Standard deviation of log2 expression of gene %s in strain%s: %.2f\n', g1, s2, sigma_Y1);
fprintf('Standard deviation of log2 expression of gene %s in strain%s: %.2f\n', g2, s1, sigma_X2);
fprintf('Standard deviation of log2 expression of gene %s in strain%s: %.2f\n', g2, s2, sigma_Y2);

fprintf('Fold change in %s: %.1f (p = %.1e)\n', g1, foldchange_g1, pvalue_g1);
fprintf('Fold change in %s: %.1f (p = %.1e)\n', g2, foldchange_g2, pvalue_g2);

%% Question 2.1 - p-values
PValues = mattest(DataX, DataY, 'VarType', 'equal');
log2FC = mean(DataX, 2) - mean(DataY, 2);

%% Question 2.2 - Volcano plot
mavolcanoplot(DataX, DataY, PValues, 'Labels', genes, 'PCUTOFF', 0.05, 'FOLDCHANGE', 2.0);
figure(3);
plot(log2FC, -log10(PValues), '.');
title('Volcano plot');
xlabel('log_2 fold change');
ylabel('-log_{10}(p-value)');
print -dpdf volcano

fprintf('Up Regulated (strain%s vs strain%s): %s\n', s1, s2, ...
        strjoin(genes(PValues < 0.05 & log2FC > log2(2))', ','));
fprintf('Dpwn Regulated (strain%s vs strain%s): %s\n', s1, s2, ...
        strjoin(genes(PValues < 0.05 & log2FC < -log2(2))', ','));

%% Question 2.3 - FWER - Bonferroni
PValues_FWER = PValues*length(genes);
fprintf('Up Regulated (strain%s vs strain%s, FWER): %s\n', s1, s2, ...
        strjoin(genes(PValues_FWER < 0.05 & log2FC > log2(2))', ','));
fprintf('Down Regulated (strain%s vs strain%s, FWER): %s\n', s1, s2, ...
        strjoin(genes(PValues_FWER < 0.05 & log2FC < -log2(2))', ','));

%% Question 2.4 - Storey's FDR correction
[~, QValues] = mafdr(PValues);
mavolcanoplot(DataX, DataY, QValues, 'Labels', genes, 'PCUTOFF', 0.05, 'FOLDCHANGE', 2.0);
figure(5);
plot(log2FC, -log10(QValues), '.');
title('Volcano plot (FDR)');
xlabel('log_2 fold change');
ylabel('-log_{10}(p-value)');
print -dpdf volcano_fdr

fprintf('Up Regulated (strain%s vs strain%s, FDR): %s\n', s1, s2, ...
        strjoin(genes(QValues < 0.05 & log2FC > log2(2))', ','));
fprintf('Down Regulated (strain%s vs strain%s, FDR): %s\n', s1, s2, ...
        strjoin(genes(QValues < 0.05 & log2FC < -log2(2))', ','));

%% Question 2.5
DataX = eval(['expression.strain' s1]);
DataY = eval(['expression.strain' s3]);
log2FC = mean(DataX, 2) - mean(DataY, 2);
PValues = mattest(DataX, DataY, 'VarType', 'equal');
[FDR, QValues] = mafdr(PValues);

fprintf('Up Regulated (strain%s vs strain%s, FDR): %s\n', s1, s3, ...
        strjoin(genes(QValues < 0.05 & log2FC > log2(2))', ','));
fprintf('Down Regulated (strain%s vs strain%s, FDR): %s\n', s1, s3, ...
        strjoin(genes(QValues < 0.05 & log2FC < -log2(2))', ','));
