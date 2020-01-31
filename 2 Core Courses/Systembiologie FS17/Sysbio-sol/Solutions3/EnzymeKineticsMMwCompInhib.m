%% Create a model named EnzymeKineticsMMwCompInhib
modelObjMMwCompInhib = sbiomodel('EnzymeKineticsMMwCompInhib');

% Define simulation time
configsetObj = getconfigset(modelObjMMwCompInhib);
set(configsetObj, 'StopTime', 90);
%% Add a compartment named cell to the model object 
compartment = addcompartment(modelObjMMwCompInhib, 'cell');

%% Add three species, S (substrate), P (product), E (enzyme), I (competitive inhibitor)
species_1 = addspecies(modelObjMMwCompInhib, 'S','InitialAmount',10);
species_2 = addspecies(modelObjMMwCompInhib, 'E','InitialAmount',1);
species_4 = addspecies(modelObjMMwCompInhib, 'P','InitialAmount',0);
species_4 = addspecies(modelObjMMwCompInhib, 'I','InitialAmount',10);

%% Add the Km value, the Kcat value and the Ki value of the enzyme as parameters to the model
parameter = addparameter(modelObjMMwCompInhib, 'Km', 20);
parameter = addparameter(modelObjMMwCompInhib, 'Kcat', 2);
parameter = addparameter(modelObjMMwCompInhib, 'Ki', 6);

%% Add the reaction to the model
reactionObj = addreaction(modelObjMMwCompInhib, 'S -> P', 'ReactionRate', 'Kcat*E*S/(S+Km*(1 + I/Ki))');

simData = sbiosimulate(modelObjMMwCompInhib);

%% Identify the reaction rates for different (initial) substrate concentrations
% get the "S" species in order to gradually increase its concentration

modelObjMMwCompInhib.Species % print the Species in the model
speciesS = modelObjMMwCompInhib.Species(1); % select species S, which is the first in the array

counter = 1;
for i=1:1:900
    % set the concentration of substrate species (S) to "i" units
    set(speciesS,'InitialAmount',i);
    % simulate the ODE model
    simData = sbiosimulate(modelObjMMwCompInhib);
    %get the data of time and Product
    [time, data_P] = select(simData, {'name','P'});
    % find the rate of product (dP/dt)
    tmpRate = diff(data_P)./diff(time);
    % alternatively
    % tmpRate = diff(simData.Data(:,3))./diff(simData.Time);
    ReactionRate(counter) = max(tmpRate);
    counter = counter+1;
end
plot(1:900,ReactionRate);
