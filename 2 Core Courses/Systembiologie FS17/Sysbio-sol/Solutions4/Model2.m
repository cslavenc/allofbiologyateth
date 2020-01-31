function [modelObj2] = Model2()

%% Create a model named Model2
modelObj2 = sbiomodel('Model2');

% Define simulation time
configsetObj = getconfigset(modelObj2);
set(configsetObj, 'StopTime', 10);
%% Add a compartment named cell to the model object 
compartment = addcompartment(modelObj2, 'cell');

%% Add two species, F6P and PEP
species_1 = addspecies(modelObj2, 'F6P','InitialAmount',3);
species_2 = addspecies(modelObj2, 'PEP','InitialAmount',0.5);

%% Add the Km value, the Kcat value and the Ki value of the enzyme as parameters to the model
parameter = addparameter(modelObj2, 'VmaxPFK', 5);
parameter = addparameter(modelObj2, 'KmPFK', 0.16);
parameter = addparameter(modelObj2, 'a', -2);
parameter = addparameter(modelObj2, 'VmaxPYK', 5);
parameter = addparameter(modelObj2, 'KmPYK', 0.31);
parameter = addparameter(modelObj2, 'Influx', 2,'ConstantValue', 0);

%% Add the reaction to the model
reactionObj = addreaction(modelObj2, 'null -> F6P', 'ReactionRate', 'Influx');
reactionObj = addreaction(modelObj2, 'F6P -> PEP', 'ReactionRate', 'VmaxPFK*(PEP^a)*F6P/(KmPFK + F6P)');
reactionObj = addreaction(modelObj2, 'PEP -> null', 'ReactionRate', 'VmaxPYK*PEP/(KmPYK + PEP)');

%% Simulate model and plot data
simData = sbiosimulate(modelObj2);
figure;
plot(simData.Time,simData.Data(:,[1 2]))
legend('F6P','PEP')

%% Step - like Input
addevent(modelObj2, 'time>= 40', {'Influx = 5'});
% Simulate model and plot data
set(configsetObj, 'StopTime', 200);
simData = sbiosimulate(modelObj2);
figure;
plot(simData.Time,simData.Data(:,[1 2]))
legend('F6P','PEP')

%% Pulse - like Input
addevent(modelObj2, 'time>= 40', {'Influx = 4.3'});
addevent(modelObj2, 'time>= 80', {'Influx = 2'});
% Simulate model and plot data
set(configsetObj, 'StopTime', 200);
simData = sbiosimulate(modelObj2);
figure;
plot(simData.Time,simData.Data(:,[1 2]))
legend('F6P','PEP')

end

