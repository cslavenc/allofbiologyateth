% Script that creates a model describing Enzyme Kinetics, based on reactions that follow the Mass Action law

%% Create a model named EnzymeKineticsMassAction
modelObjMassAction = sbiomodel('EnzymeKineticsMassAction');

%% Add a compartment named cell to the model object 
compartment = addcompartment(modelObjMassAction, 'cell');

%% Add four species, S (substrate), P (product), E (free enzyme), ES (Enzyme - Substrate complex) 
species_1 = addspecies(modelObjMassAction, 'S','InitialAmount',10);
species_2 = addspecies(modelObjMassAction, 'E','InitialAmount',1);
species_3 = addspecies(modelObjMassAction, 'ES','InitialAmount',0);
species_4 = addspecies(modelObjMassAction, 'P','InitialAmount',0);

%% Add the reaction rate constants as parameters, K1, to model with a value of 3
parameter1 = addparameter(modelObjMassAction, 'k1pos', 0.1);
parameter2 = addparameter(modelObjMassAction, 'k1neg', 0.01);
parameter3 = addparameter(modelObjMassAction, 'k2pos', 1.99);

%% Add the reactions to the model
% Reaction E + S -> ES 
reactionObj1 = addreaction(modelObjMassAction, 'E + S -> ES', 'ReactionRate', 'k1pos*E*S');
% Reaction ES -> E + S
reactionObj2 = addreaction(modelObjMassAction, 'ES -> E + S', 'ReactionRate', 'k1neg*ES');
% Reaction ES -> E + P
reactionObj3 = addreaction(modelObjMassAction, 'ES -> E + P', 'ReactionRate', 'k2pos*ES');

%% Simulate model and plot data
% set simulation time
configsetObj = getconfigset(modelObjMassAction);
set(configsetObj, 'StopTime', 100);
% simulate model and save results in the simData struct
simData = sbiosimulate(modelObjMassAction);
[time, data_A] = select(simData, {'name','S'})
plot(time, data_A, '-b');
%you could also plot the data directly, by directly using the fields of the simData structure
%plot(simData.time,simData.Data(:,1),'-b');  

% now hold the same plot, in order to plot on it the results of species B 
hold on;
% plot simulation results of species B, with red color (this information is contained in the simData %object). First get the time vector and the simulated data of species ‘B’
[time, data_B] = select(simData, {'name','E'})
 % then plot the data with red color
plot(time, data_B, '-r');
%you could also plot the data directly, by directly using the fields of the simData structure
%plot(simData.time,simData.Data(:,2),'-r');
[time, data_C] = select(simData, {'name','ES'})
 % then plot the data with red color
plot(time, data_C, '-k');
%you could also plot the data directly, by directly using the fields of the simData structure
%plot(simData.time,simData.Data(:,2),'-r');
[time, data_D] = select(simData, {'name','P'})
 % then plot the data with red color
plot(time, data_D, '-g');
%you could also plot the data directly, by directly using the fields of the simData structure
%plot(simData.time,simData.Data(:,2),'-r');
