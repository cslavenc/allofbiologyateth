%% E.coli FBA model
load ecoli_core_model.mat

initCobraToolbox

changeCobraSolver('glpk')
%% familiarize with the toolbox
% calculate optimal flux distribution
[solution] = optimizeCbModel(model, 'max','one');
% import the E.coli CCM network
 map = readCbMap('ecoli_core_map.txt')	
%  changeCbMapOutput('matlab') 
 changeCbMapOutput('svg'); 
 drawCbMap(map)
% draw the E.coli CCM network and optimal flux distribution
drawFlux(map, model, solution.x, [], 'ZeroFluxWidth', 1, 'lb', -15, 'ub', 15, 'FileName', 'Point3.svg');

%% simulate PGI knockout
indg = find(strcmp(model.genes,'b4025'));
indr1 = find(model.rxnGeneMat(:,indg));

modelPGI = model;
modelPGI.lb(indr1) = 0;
modelPGI.ub(indr1) = 0;
[solutionPGI] = optimizeCbModel(modelPGI, 'max','one');
drawFlux(map, model, solutionPGI.x, [], 'ZeroFluxWidth', 1, 'lb', -15, 'ub', 15, 'FileName', 'PGI.svg');

%% simulate ZWF knockout
indg = find(strcmp(model.genes,'b1852'));
indr2 = find(model.rxnGeneMat(:,indg));

modelZWF = model;
modelZWF.lb(indr2) = 0;
modelZWF.ub(indr2) = 0;
[solutionZWF] = optimizeCbModel(modelZWF, 'max','one');
drawFlux(map, model, solutionZWF.x, [], 'ZeroFluxWidth', 1, 'lb', -15, 'ub', 15, 'FileName', 'ZWF.svg');

%% simulate PGI-ZWF double knckout


modelPGIZWF = model;
modelPGIZWF.lb([indr1 indr2]) = 0;
modelPGIZWF.ub([indr1 indr2]) = 0;
[solutionPGIZWF] = optimizeCbModel(modelPGIZWF, 'max','one');

solution.f
solutionPGI.f
solutionZWF.f
solutionPGIZWF.f


%%