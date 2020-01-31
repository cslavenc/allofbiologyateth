function [modelObj1] = Model1()

%% Create a model named Model1
modelObj1 = sbiomodel('Model1');

% Define simulation time (here simulation time is set for 10 seconds)
configsetObj = getconfigset(modelObj1);
set(configsetObj, 'StopTime', 10);

%% Add a compartment named cell to the model object 
compartment = addcompartment(modelObj1, 'cell');

%% Add three species, S (substrate), P (product), E (enzyme), I (competitive inhibitor)
species_1 = addspecies(modelObj1, 'F6P','InitialAmount',3);
species_2 = addspecies(modelObj1, 'PEP','InitialAmount',0.5);

%% Add the Km value, the Kcat value and the Ki value of the enzyme as parameters to the model
parameter = addparameter(modelObj1, 'VmaxPFK', 5);
parameter = addparameter(modelObj1, 'KmPFK', 0.16);
parameter = addparameter(modelObj1, 'VmaxPYK', 5);
parameter = addparameter(modelObj1, 'KmPYK', 0.31);
parameter = addparameter(modelObj1, 'Influx', 2,'ConstantValue', 0);

%% Add the reaction to the model
reactionObj = addreaction(modelObj1, 'null -> F6P', 'ReactionRate', 'Influx');
reactionObj = addreaction(modelObj1, 'F6P -> PEP', 'ReactionRate', 'VmaxPFK*F6P/(KmPFK + F6P)');
reactionObj = addreaction(modelObj1, 'PEP -> null', 'ReactionRate', 'VmaxPYK*PEP/(KmPYK + PEP)');

%% Simulate model and plot data
simData = sbiosimulate(modelObj1);
% sbioplot(simData);

plot(simData.Time,simData.Data(:,[1 2]))
legend('F6P','PEP')
%% Parameter Scan
% here done only for parameter KmPFK
% obtain the parameter
parameter = sbioselect(modelObj1,'Type','parameter','Where','Name','==','KmPFK');
% loop around the range that we defined
figure(1); % create one figure to plot F6P data
figure(2); % create another figure to plot PEP data
for i=0.16:0.1:5
    % set the new value of the parameter
    set(parameter,'Value',i);
    % simulate model with altered parameter
    simData = sbiosimulate(modelObj1);
    % plot data for F6P
    [time, data_F6P] = select(simData, {'name','F6P'});
    figure(1);
    plot(time,data_F6P)
    hold on;
    % plot data for PEP
    [time, data_PEP] = select(simData, {'name','PEP'});
    figure(2);
    plot(time,data_PEP,'-g');
    hold on;
    
end
figure(1);
legend('F6P');
hold off;
figure(2);
legend('PEP');
hold off;

% restore parameter value to default
parameter = sbioselect(modelObj1,'Type','parameter','Where','Name','==','KmPFK');
set(parameter,'Value', 0.16);

%% Step - like Input after 40 seconds
addevent(modelObj1, 'time>= 40', {'Influx = 5'});

%% Simulate model and plot data
% change the simulation time to 200 seconds
set(configsetObj, 'StopTime', 200);
simData = sbiosimulate(modelObj1);
figure;
plot(simData.Time,simData.Data(:,[1 2]))
legend('F6P','PEP')

%% Pulse - like Input
addevent(modelObj1, 'time>= 40', {'Influx = 5'});
addevent(modelObj1, 'time>= 80', {'Influx = 2'});

%% Simulate model and plot data
set(configsetObj, 'StopTime', 200);
simData = sbiosimulate(modelObj1);
figure;
plot(simData.Time,simData.Data(:,[1 2]))
legend('F6P','PEP')

end

