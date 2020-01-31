% Exercise 9 - Slaven Cvijetic, 26.04.2017
% The statistical part was difficult.

load('ex9.mat');

% PART 1.1
% mean(expression.strain01,1);
mvec = mean(expression.strain01,2); % if dim=2, then we calculate the mean of
% every row. This gives 4297 means. That's what we want, since there are
% 4297 genes.

% std(expression.strain01,0,1);
svec = std(expression.strain01,0,2);

% PART 1.2
hist(mvec, 50);
hold on
hist(svec, 50);
hold off

% PART 1.3
%stdvec = [];
%names = [];
%N_ = size(svec);
%N = N_(0)
%Tried to create an own function, but there was some unknown error...
%stdvec, names = search_genes(svec,0.6,genes,N)

stdvec_ind = find(svec>0.6);
names = genes(stdvec_ind);
display(names)

% PART 1.4
ind_dinI = find(ismember(genes, 'dinI'));
ind_rydC = find(ismember(genes, 'rydC'));

std_dinI_01 = svec(ind_dinI);
std_rydC_01 = svec(ind_rydC);

mean_dinI_01 = mvec(ind_dinI);
mean_rydC_01 = mvec(ind_rydC);

% The same for strain04.

mvec04 = mean(expression.strain04, 2);
svec04 = std(expression.strain04, 0, 2);

std_dinI_04 = svec04(ind_dinI);
mean_dinI_04 = mvec04(ind_dinI);

std_rydC_04 = svec04(ind_rydC);
mean_rydC_04 = mvec04(ind_rydC);

%PART 1.5
alpha = 0.05;
n = 3;
t1 = abs(mean_dinI_01 - mean_dinI_04)/(sqrt(std_dinI_01^2 + std_dinI_04^2)/n);
t2  = abs(mean_rydC_01 - mean_rydC_04)/(sqrt(std_rydC_01^2 + std_rydC_04^2)/n);

p1 = 2 - 2*tcdf(t1,4);
p2 = 2 - 2*tcdf(t2,4);

change_indI01 = 2^(expression.strain01(ind_dinI,3)/expression.strain01(ind_dinI,1));
change_indI04 = 2^(expression.strain04(ind_dinI,3)/expression.strain04(ind_dinI,1));
change_rydC01 = 2^(expression.strain01(ind_rydC,3)/expression.strain01(ind_rydC,1));
change_rydC04 = 2^(expression.strain04(ind_rydC,3)/expression.strain04(ind_rydC,1));

%since t1, t2, p1, p2 are calculated using data from a log2 scale, we need
%to modify these values to a linear scale.

p1_ = 2^p1;
p2_ = 2^p2;

%Since we have calculated t, we can define the interval K = [-inf, -t] u
%[t,+inf]. If p_ is in K, then we have a significant change.

%from a table we find t = 3.182 with alpha = 0.05 and n = df = 3.
t = 3.182;
display(t1)
display(t2)
display(t)
display(-t)

%the change in indI is significant.

%PART 2.1
PValues01 = mattest(expression.strain01(:,3),expression.strain01(:,1), 'VarType', 'equal');
PValues04 = mattest(expression.strain04(:,3),expression.strain04(:,1), 'VarType', 'equal');

%PART 2.2
struc1 = mavolcanoplot(expression.strain01(:,3),expression.strain01(:,1), PValues01, 'Labels', genes);
struc2 = mavolcanoplot(expression.strain04(:,3),expression.strain04(:,1), PValues01, 'Labels', genes);

%PART 2.3
m = 2;
FWER = alpha/m;
t_FWER = 4.541;

%PART 2.4
