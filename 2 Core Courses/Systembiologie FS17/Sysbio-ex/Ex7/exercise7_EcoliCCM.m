%% E.coli FBA model
% 1. Loading and analyzing the model
load ecoli_core_model.mat

% 1.1 Find the id, name and formula for metabolite 34. 
metidx = 34; 
metid = model.mets(metidx)
metname = model.metNames(metidx)               %ADD CODE HERE
metformula = model.metFormulas(metidx)            %ADD CODE HERE

% 1.2 Find reaction names consuming metabolite 34
rxnidx = find(S.(:,metidx) == -1)           %ADD CODE HERE
rxnnames = model.rxnNames(rxnidx) %get the reaction names

% 1.3 Find gene catalyzing reaction 48
rxnidx = 48;
geneidx = find(...          %ADD CODE HERE
genename = model.genes(geneidx); %get the gene name


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Analyzing media composition and biomass vector
% 2.1 get the indices of reactions containing "EX_"
exchangeidx = find(cellfun(@(x) ~isempty(strfind(x, 'EX_')), model.rxns)); 

exchangenames = model.rxns(exchangeidx)
medialb = model.lb(exchangeidx)

mediapresent = ...          %ADD CODE HERE

% 2.2 Identify major carbon source - find the largest coefficient
mediacoefs = model.lb(...   %ADD CODE HERE 

% 2.3 Index of biomass reaction - find it by looking at model.rxns in the workspace
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. FBA optimization with COBRA toolbox 
% add Cobra toolbox folder to path
addpath([pwd filesep 'opencobra-cobratoolbox-4482ec0']);
%% 3.1 initilalize Cobra toolbox
initCobraToolbox
%% define the solver for optimization task
changeCobraSolver('glpk')

%% 3.2 Visualize E. coli map
% import the E.coli CCM network for visualization purposes
map = readCbMap('ecoli_core_map.txt')	
%  changeCbMapOutput('matlab') 
changeCbMapOutput('svg');

%% 3.3 draw the loaded E. coli metabolic map (in file 'target.svg')
drawCbMap(map)

%% 3.4 Find the optimization vector in the model
optrxn = model.rxns(model.c>0); 


%% 3.5 calculate optimal flux distribution
% (objective coefficients are defined in the model structure)
[solution] = optimizeCbModel(model, 'max','one');

%% 3.6. draw the E.coli CCM network and optimal flux distribution
drawFlux(map, model, solution.x, [], 'ZeroFluxWidth', 1, 'lb', -15, 'ub', 15, 'FileName', 'Point3.svg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Gene essentiality

%% 4.1 simulate ZWF knockout
indg = find(strcmp(model.genes,'b1852'));
indr2 = find(model.rxnGeneMat(:,indg));

modelZWF = model;
modelZWF.lb(indr2) = 0;
modelZWF.ub(indr2) = 0;

%% 4.2 Find optiomal flux solution for ZWF knockout
[solutionZWF] = optimizeCbModel(modelZWF, 'max','one');

%% 4.3 Visualize and save the solution
drawFlux(map, model, solutionZWF.x, [], 'ZeroFluxWidth', 1, 'lb', -15, 'ub', 15, 'FileName', 'ZWF.svg');



%% 4.4 simulate PGI knockout
indg = find(strcmp(model.genes,'b4025'));
indr1 = find(model.rxnGeneMat(:,indg));

modelPGI = model;
modelPGI.lb(indr1) = 0;
modelPGI.ub(indr1) = 0;
[solutionPGI] = optimizeCbModel(modelPGI, 'max','one');
drawFlux(map, model, solutionPGI.x, [], 'ZeroFluxWidth', 1, 'lb', -15, 'ub', 15, 'FileName', 'PGI.svg');

%% 4.5 Open and compare files 'Point3.svg', 'PGI.svg' and 'ZWF.svg'


%% 4.6. simulate PGI-ZWF double knckout

modelPGIZWF = model;
    
% block the reactions catalyzed by both enzymes
modelPGIZWF.lb(.........) = 0;
modelPGIZWF.ub(........) = 0;
% search the optimal solution
[solutionPGIZWF] = optimizeCbModel(........, 'max','one');

% wild-type maximum growth
solution.f
% PGI knockout maximum growth
solutionPGI.f
% ZWF knockout maximum growth
solutionZWF.f
% PGI-ZWF knockout maximum growth
solutionPGIZWF.f
