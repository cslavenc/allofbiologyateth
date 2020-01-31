%% Create a model named EnzymeKineticsMM
modelObjMM = sbiomodel('EnzymeKineticsMM');

% Define simulation time
configsetObj = getconfigset(modelObjMM);
set(configsetObj, 'StopTime', 30);

%% Add a compartment named cell to the model object 
compartment = addcompartment(modelObjMM, 'cell');

%% Add three species, S (substrate), P (product), E (enzyme)
species1 = addspecies(modelObjMM, 'S','InitialAmount',10);
species2 = addspecies(modelObjMM, 'E','InitialAmount',1);
species3 = addspecies(modelObjMM, 'P','InitialAmount',0);

%% Add the Km value and the Kcat value of the enzyme as parameters to the model
parameter1 = addparameter(modelObjMM, 'Km', 20);
parameter2 = addparameter(modelObjMM, 'Kcat', 2);

%% Add the reaction to the model
reactionObj = addreaction(modelObjMM, 'S -> P', 'ReactionRate', 'Kcat*E*S /(S+Km)');

%% Identify the reaction rates for different (initial) substrate concentrations
% get the "S" species in order to gradually increase its concentration

modelObjMM.Species % print the Species in the model
speciesS = modelObjMM.Species(1); % select species S, which is the first in the array

counter = 1; % initialize counter
for i=1:1:600
    % set the concentration of substrate species (S) to "i" units
    set(speciesS,'InitialAmount',i);
    % simulate the ODE model
    simData = sbiosimulate(modelObjMM);
    %get the data of time and Product
    [time, data_P] = select(simData, {'name','P'});
    % find the rate of product (dP/dt)
    tmpRate = diff(data_P)./diff(time);
    % alternatively
    % tmpRate = diff(simData.Data(:,3))./diff(simData.Time);
    ReactionRateMM(counter) = max(tmpRate);
    counter = counter+1;
end