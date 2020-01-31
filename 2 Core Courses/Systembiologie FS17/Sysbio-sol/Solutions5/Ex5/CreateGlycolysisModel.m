%Slaven Cvijetic
%Hello! For some reason, I was not able to change the parameters with the
%sbioselect() function for some of the exercise and I simply cannot find
%the mistake... That's why, my plots are incorrect.
%% Create a model
modelObj = sbiomodel('ECoGlucose');

%% Set initial concentrations of species
addspecies(modelObj, 'G6P','InitialAmount',3);
addspecies(modelObj, 'F6P','InitialAmount',0.07);
addspecies(modelObj, 'FBP','InitialAmount',0.16);
addspecies(modelObj, 'SixPG','InitialAmount',0.09);
addspecies(modelObj, 'DHAP','InitialAmount',0.849);
addspecies(modelObj, 'PEP','InitialAmount',0.563);
addspecies(modelObj, 'PYR','InitialAmount',0.81);

%--------------- ADD CODE HERE FOR THE INITIALIZATION OF THE REST OF THE SPECIES ------------------%

%% -----------------------------------------------------%
%                  IRREVERSIBLE REACTIONS               %
%  -----------------------------------------------------%
%% 1st reaction 
reactionObj = addreaction(modelObj, 'PEP -> G6P + PYR','ReactionRate','Vmax1');
% Define the parameter value of Glucose Influx as the maximum rate of this
% reaction. In this case we make the assumption that we know (have measured) the flux value. This is why we don't need
% to write the rate as a Michaelis Menten for example. 
addparameter(modelObj, 'Vmax1', 0.73);

%% 2nd Reaction
reactionObj = addreaction(modelObj, 'F6P -> FBP','ReactionRate', 'Vmax2 * F6P / (F6P + Km2)');
% Define the parameter values of Vmax and Km for this reaction
addparameter(modelObj, 'Vmax2', 2.58);
addparameter(modelObj, 'Km2', 0.16);

%% 3rd Reaction
reactionObj = addreaction(modelObj, 'FBP -> F6P','ReactionRate', 'Vmax3 * FBP / (FBP + Km3)');
addparameter(modelObj, 'Vmax3', 0.28);
addparameter(modelObj, 'Km3', 0.015);
%--------------- ADD CODE HERE ------------------%


%% 4th Reaction
reactionObj = addreaction(modelObj, 'G6P -> SixPG','ReactionRate', 'Vmax4 * G6P / (G6P + Km4)');
addparameter(modelObj, 'Vmax4', 0.31);
addparameter(modelObj, 'Km4', 0.07);
%--------------- ADD CODE HERE ------------------%


%% 5th Reaction
reactionObj = addreaction(modelObj, 'SixPG -> null','ReactionRate', 'Vmax5 * SixPG / (SixPG + Km5)');
addparameter(modelObj, 'Vmax5', 0.46);
addparameter(modelObj, 'Km5', 0.1);
%--------------- ADD CODE HERE ------------------%


%% 6th Reaction
reactionObj = addreaction(modelObj, 'PEP -> PYR','ReactionRate', 'Vmax6 * PEP / (PEP + Km6)');
addparameter(modelObj, 'Vmax6', 3.16);
addparameter(modelObj, 'Km6', 0.31);
%--------------- ADD CODE HERE ------------------%


%% 7th Reaction
reactionObj = addreaction(modelObj, 'PYR -> PEP','ReactionRate', 'Vmax7 * PYR / (PYR + Km7)');
addparameter(modelObj, 'Vmax7', 0.16);
addparameter(modelObj, 'Km7', 0.083);
%--------------- ADD CODE HERE ------------------%

 
%% 8th Reaction
% This reaction will be used only in the last part of the exercise, and its purpose is
% to demostrate to you that (obviously) we could have different inputs /
% influxes to our model, and this would be a way to model it. In this case,
% the alternative input to our model is Fructose. In this case we make the assumption that we know (have measured) the 
% flux value. This is why we don't need to write the rate as a Michaelis Menten for example. 
reactionObj = addreaction(modelObj, 'PEP -> FBP + PYR', 'ReactionRate', 'Vmax8');
% define the value of Pyruvate Influx as 0, initially, as it is not present
addparameter(modelObj, 'Vmax8', 0);

%% 9th Reaction
reactionObj = addreaction(modelObj, 'PYR -> null', 'ReactionRate', 'Vmax9 * PYR / (PYR + Km9)');
% Define the parameter values of Vmax and Km for this reaction
addparameter(modelObj, 'Vmax9', 3.48);
addparameter(modelObj, 'Km9', 0.515);

%% 10th Reaction
reactionObj = addreaction(modelObj, 'PEP -> null','ReactionRate', 'Vmax10 * PEP / (PEP + Km10)');
addparameter(modelObj, 'Vmax10', 1.52);
addparameter(modelObj, 'Km10', 0.19);
%--------------- ADD CODE HERE ------------------%


%% -----------------------------------------------------%
%                  REVERSIBLE REACTIONS                 %
%  -----------------------------------------------------%

%% 11th Reaction
reactionObj = addreaction(modelObj, 'G6P <-> F6P','ReactionRate', 'Vmax11forward*G6P - Vmax11backward*F6P');
addparameter(modelObj, 'Vmax11forward', 11);
addparameter(modelObj, 'Vmax11backward', 10);
%--------------- ADD CODE HERE ------------------%


%% 12th Reaction
% This reaction has a bit different stoichiometry than all the rest, and
% therefore it is provided. 
reactionObj = addreaction(modelObj, 'FBP <-> 2 DHAP', 'ReactionRate','Vmax12forward*FBP - Vmax12backward*DHAP^2');
% define the parameter values for both forward and backward reactions
addparameter(modelObj, 'Vmax12forward', 11);
addparameter(modelObj, 'Vmax12backward', 10);

%% 13th Reaction
reactionObj = addreaction(modelObj, 'DHAP <-> PEP','ReactionRate', 'Vmax13forward*DHAP - Vmax13backward*PEP');
addparameter(modelObj, 'Vmax13forward', 11);
addparameter(modelObj, 'Vmax13backward', 10);
%--------------- ADD CODE HERE ------------------%


%% Simulate
configsetObj = getconfigset(modelObj);
set(configsetObj, 'StopTime', 40);

%Get data and plot graph in case of glucose influx only.
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1]));
xlabel('time-axis in seconds');
ylabel('Vmax1 in mM/sec (Glucose influx)');
legend('Glucose influx');
title('t = 40')

%Plot all metabolites in one figure.
figure;
%sbioplot(simData);
plot(simData.Time, simData.Data(:, [1 2 3 4 5 6 7]));
legend('G6P','F6P','FBP','SixPG','DHAP','PEP','PYR');

configsetObj = getconfigset(modelObj);
set(configsetObj, 'StopTime', 10);
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1]));
xlabel('time-axis in seconds');
ylabel('Vmax1 in mM/sec (Glucose influx)');
legend('Glucose influx');
title('t = 10')

configsetObj = getconfigset(modelObj);
set(configsetObj, 'StopTime', 2);
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1]));
xlabel('time-axis in seconds');
ylabel('Vmax1 in mM/sec (Glucose influx)');
legend('Glucose influx');
title('t = 2')


%PART 4:
configsetObj = getconfigset(modelObj);
set(configsetObj, 'StopTime', 40);
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1 3]));
title('G6P and FBP figure 1');


parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','G6P');
set(parameter,'Value', 0.03);
parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','FBP');
set(parameter,'Value', 0.001);
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1 3]));
title('G6P = 0.03 and FBP = 0.001');

parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','G6P');
set(parameter,'Value', 0.01);
parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','FBP');
set(parameter,'Value', 4);
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1 3]));
title('G6P = 0.01 and FBP = 4');

%PART 5:
%Restore values of G6P and FBP
parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','G6P');
set(parameter,'Value', 3);
parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','FBP');
set(parameter,'Value', 0.16);

configsetObj = getconfigset(modelObj);
set(configsetObj, 'StopTime', 100);
parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','Vmax1');
set(parameter,'Value', 0.03);
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1 2 3 4 5 6 7]));
title('Vmax1 = 0.03');
legend('G6P','F6P','FBP','SixPG','DHAP','PEP','PYR');

parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','Vmax1');
set(parameter,'Value', 0.55);
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1 2 3 4 5 6 7]));
title('Vmax1 = 0.55');
legend('G6P','F6P','FBP','SixPG','DHAP','PEP','PYR');

parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','Vmax1');
set(parameter,'Value', 1.15);
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1 2 3 4 5 6 7]));
title('Vmax1 = 1.15');
legend('G6P','F6P','FBP','SixPG','DHAP','PEP','PYR');

parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','Vmax1');
set(parameter,'Value', 2.10);
simData = sbiosimulate(modelObj);
figure;
plot(simData.Time, simData.Data(:,[1 2 3 4 5 6 7]));
title('Vmax1 = 2.10');
legend('G6P','F6P','FBP','SixPG','DHAP','PEP','PYR');

%PART 6:
figure;
plot(simData.Time, simData.Data(:,[3]));
title('Increased glucose influx and FBP differences');
hold on

parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','Vmax1');
set(parameter,'Value', 0.73);
simData = sbiosimulate(modelObj);
plot(simData.Time, simData.Data(:,[3]));
legend('FBP with increased influx', 'FBP with initial influx');
hold off

%PART 7:
configsetObj = getconfigset(modelObj);
set(configsetObj, 'StopTime', 100);
parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','Vmax1');
set(parameter,'Value', 0);
parameter = sbioselect(modelObj,'Type','parameter','Where','Name','==','Vmax8');
set(parameter,'Value', 1.8);
simData = sbiosimulate(modelObj);
plot(simData.Time, simData.Data(:,[1:7]));
title('Fructose influx only without glucose influx');
legend('G6P','F6P','FBP','SixPG','DHAP','PEP','PYR');

%--------------- ADD CODE HERE ------------------%

