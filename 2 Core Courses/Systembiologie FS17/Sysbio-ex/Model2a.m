function [modelObj2] = Model2()

%% Create a model named Model1
modelObj2 = sbiomodel('Model2');

% Define simulation time (here simulation time is set for 10 seconds)
configsetObj = getconfigset(modelObj2);
set(configsetObj, 'StopTime', 10);

%% Add a compartment named cell to the model object 
compartment = addcompartment(modelObj2, 'cell');

%% Add two species, F6P and PEP
species = addspecies(modelObj2, 'F6P','InitialAmount',3);
species2 = addspecies(modelObj2, 'PEP','InitialAmount',0.5);
%------------- ADD CODE HERE ------------%

%% Add the Km values, and the rest of Vmax values as parameters to the model

parameter0 = addparameter(modelObj2, 'VmaxPFK', 5);
% here you need the "ConstantValue" attribute to be turned off (thus set to 0) in order to be able to change it for the
% last part of the exercise. Please add the rest of the code needed below.
parameter1 = addparameter(modelObj2, 'Influx', 2,'ConstantValue', 0);
parameter2 = addparameter(modelObj2, 'VmaxPYK', 5);
parameter3 = addparameter(modelObj2, 'KmPFK', 0.16);
parameter4 = addparameter(modelObj2, 'KmPYK', 0.31);
parameter5 = addparameter(modelObj2, 'a', -2);
%------------- ADD CODE HERE ------------%

%% Add the reaction to the model

% Important comment: in a reaction, in order to have generation (from "zero") or drain of a metabolite you have 
% to denote it in the addraction() function, with the word "null". An example of the first reaction of the system is
% given below. Complete the rest.
% I am supposed to add Michaelis-Menten equations.

reactionObj = addreaction(modelObj2, 'null -> F6P', 'ReactionRate', 'Influx');
reactionObj2 = addreaction(modelObj2, 'F6P -> PEP', 'ReactionRate', 'VmaxPFK*F6P/(F6P+KmPFK)');
reactionObj3 = addreaction(modelObj2, 'PEP -> null', 'ReactionRate', 'VmaxPYK*(PEP)^a/(((PEP)^a)+KmPYK)');
%------------- ADD CODE HERE ------------%

%% Simulate model and plot data
% simData contains all the data from the simulation
simData = sbiosimulate(modelObj2);
[time, Data1] = select(simData, {'name','F6P'});
plot(time, Data1, '-k');
hold on
%display(time, Data1)

%% Plot data

%------------- ADD CODE HERE ------------%

%% Parameter Scan
% here done only for parameter KmPFK, you will have to do it also for VmaxPYK

% First obtain the parameter
parameter6 = sbioselect(modelObj2,'Type','parameter','Where','Name','==','KmPFK');
parameter7 = sbioselect(modelObj2,'Type','parameter','Where','Name','==','VmaxPYK');

%% --------------------------- THIS IS THE LAST PART -------------------------- %% 

%% Step - like Input after 40 seconds
addevent(modelObj2, 'time>= 40', {'Influx = 5'});

%% Simulate model and plot data
% change the simulation time to 200 seconds
set(configsetObj, 'StopTime', 200);

%------------- ADD CODE HERE ------------%

%% Pulse - like Input

%------------- ADD CODE HERE ------------%
addevent(modelObj2, 'time>= 40', {'Influx = 5'});

%% Simulate model and plot data
set(configsetObj, 'StopTime', 200);
simData = sbiosimulate(modelObj2);
% plot data
[time, Data2] = select(simData, {'name','F6P'});
plot(time, Data2,'-b');
[time, Data3] = select(simData, {'name','PEP'});
plot(time, Data3, '-r');
%------------- ADD CODE HERE ------------%

end

