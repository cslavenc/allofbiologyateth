clc
clear
close all
load ex9

%% Question 1.1
DataX = expression.strain06;
DataY = expression.strain01;

PValues = mattest(DataX, DataY, 'VarType', 'equal');
log2FC = mean(DataX, 2) - mean(DataY, 2);

[~, QValues] = mafdr(PValues);
figure(1);
plot(log2FC, -log10(QValues), '.');
title('Volcano plot (FDR)');
xlabel('log_2 fold change');
ylabel('-log_{10}(q-value)');
print -dpdf volcano_06_01

fprintf('Up Regulated: %s\n', ...
        strjoin(genes(QValues < 0.05 & log2FC > log2(2))', ', '));
fprintf('Down Regulated: %s\n', ...
        strjoin(genes(QValues < 0.05 & log2FC < -log2(2))', ', '));

%% Question 1.2
load ex10

lacI_targets = regulation(:, strcmp(transcription_factors, 'lacI'));
fprintf('Induced by lacI: %s\n', strjoin(genes(lacI_targets > 0)', ', '));
fprintf('Repressed by lacI: %s\n', strjoin(genes(lacI_targets < 0)', ', '));

%% Question 2.1
col = find(ismember(transcription_factors, 'purR'));
[~, I_ranking] = sort(PValues + (abs(log2FC) < 0.2));
features = (regulation(I_ranking, col) ~= 0);

%% Question 2.2
A = sum(features(1:50));
B = sum(~features(1:50));
C = sum(features(51:end));
D = sum(~features(51:end));
fprintf('A = %d, B = %d, C = %d, D = %d\n', A, B, C, D);

%% Question 2.3
%p = sum(hygepdf(A:A+B, A+B+C+D, A+C, A+B));
[~, p] = fishertest([A B; C D], 'Tail', 'right');
fprintf('set #50: p-value = %.2e\n', p);

%% Question 2.4-2.5
[p, i_min] = GSEA2(features, 1000, true);
fprintf('minimal set is #%d: p-value = %.2e\n', i_min, p);
print -dpdf gsea_purR

%% Question 2.6
gsea_PValues = zeros(1, length(transcription_factors));
for col = 1:length(transcription_factors)
    [gsea_PValues(col), ~] = GSEA2(regulation(I_ranking, col) ~= 0, 1000, false);
end

[~, gsea_QValues] = mafdr(gsea_PValues);
enriched_tfs = transcription_factors(gsea_QValues < 0.05);
fprintf('%d significantly enriched TFs: %s\n', length(enriched_tfs), strjoin(enriched_tfs', ', '));
