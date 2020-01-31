modelObj = sbiomodel('ECoGlucose');

%% Set initial concentrations of species
addspecies(modelObj, 'G6P','InitialAmount',3);
addspecies(modelObj, 'F6P','InitialAmount',0.07);
addspecies(modelObj, 'FBP','InitialAmount',0.16);
addspecies(modelObj, 'SixPG','InitialAmount',0.09);
addspecies(modelObj, 'DHAP','InitialAmount',0.849);
addspecies(modelObj, 'PEP','InitialAmount',0.563);
addspecies(modelObj, 'PYR','InitialAmount',0.81);

%% -----------------------------------------------------%
%                  IRREVERSIBLE REACTIONS               %
%  -----------------------------------------------------%
%% 1st reaction 
reactionObj = addreaction(modelObj, 'PEP -> G6P + PYR','ReactionRate','Vmax1');
% define the parameter value
addparameter(modelObj, 'Vmax1', 0.73);

%% 2nd Reaction
reactionObj = addreaction(modelObj, 'F6P -> FBP','ReactionRate', 'Vmax2 * F6P / (F6P + Km2)');
% define the parameter values
addparameter(modelObj, 'Vmax2', 2.58);
addparameter(modelObj, 'Km2', 0.16);

%% 3rd Reaction
reactionObj = addreaction(modelObj, 'FBP -> F6P', 'ReactionRate', 'Vmax3 * FBP / (FBP + Km3)');
% define the parameter values
addparameter(modelObj, 'Vmax3', 0.28);
addparameter(modelObj, 'Km3',0.015); 

%% 4th Reaction
reactionObj = addreaction(modelObj, 'G6P -> SixPG', 'ReactionRate', 'Vmax4 * G6P / (G6P + Km4)');
% define the parameter values
addparameter(modelObj, 'Vmax4', 0.31);
addparameter(modelObj, 'Km4',0.07); 

%% 5th Reaction
reactionObj = addreaction(modelObj, 'SixPG -> null', 'ReactionRate', 'Vmax5 * SixPG / (SixPG + Km5)');
% define the parameter values
addparameter(modelObj, 'Vmax5', 0.46);
addparameter(modelObj, 'Km5', 0.1);

%% 6th Reaction
reactionObj = addreaction(modelObj, 'PEP -> PYR', 'ReactionRate', 'Vmax6 * PEP / (PEP + Km6)');
% define the parameter values
addparameter(modelObj, 'Vmax6', 3.16);
addparameter(modelObj, 'Km6', 0.31);  

%% 7th Reaction
reactionObj = addreaction(modelObj, 'PYR -> PEP', 'ReactionRate', 'Vmax7 * PYR / (PYR + Km7)');
% define the parameter values
addparameter(modelObj, 'Vmax7', 0.16);
addparameter(modelObj, 'Km7',0.083); 

%% 8th Reaction
reactionObj = addreaction(modelObj, 'PEP -> FBP + PYR', 'ReactionRate', 'Vmax8');
% define the parameter values
addparameter(modelObj, 'Vmax8',0);

%% 9th Reaction
reactionObj = addreaction(modelObj, 'PYR -> null', 'ReactionRate', 'Vmax9 * PYR / (PYR + Km9)');
% define the parameter values
addparameter(modelObj, 'Vmax9', 3.48);
addparameter(modelObj, 'Km9', 0.515);

%% 10th Reaction
reactionObj = addreaction(modelObj, 'PEP -> null', 'ReactionRate','Vmax10 * PEP / (PEP + Km10)');
% define the parameter values
addparameter(modelObj, 'Vmax10', 1.52);
addparameter(modelObj, 'Km10',0.19);   

%% -----------------------------------------------------%
%                  REVERSIBLE REACTIONS                 %
%  -----------------------------------------------------%

%% 11th Reaction
reactionObj = addreaction(modelObj, 'G6P <-> F6P', 'ReactionRate', 'Vmax11forward*G6P - Vmax11backward*F6P');
% define the parameter values
addparameter(modelObj, 'Vmax11forward', 11);
addparameter(modelObj, 'Vmax11backward', 10);

%% 12th Reaction
reactionObj = addreaction(modelObj, 'FBP <-> 2 DHAP', 'ReactionRate','Vmax12forward*FBP - Vmax12backward*DHAP^2');
% define the parameter values 
addparameter(modelObj, 'Vmax12forward', 11);
addparameter(modelObj, 'Vmax12backward', 10);

%% 13th Reaction
reactionObj = addreaction(modelObj, 'DHAP <-> PEP', 'ReactionRate','Vmax13forward*DHAP - Vmax13backward*PEP');
% define the parameter values  
addparameter(modelObj, 'Vmax13forward', 11);
addparameter(modelObj, 'Vmax13backward', 10);

