function [score] =  scoreModels(ExperimentalData,SimulationData,StandardDeviation)

%% calculate goodness of fit

m = size(ExperimentalData,2); % get the number of metabolites
n = size(ExperimentalData,1); % get the number of time points for which we have data

score = 0;  % initialize the score
for i=1:m   % for every metabolite
    for t=1:n % for every time point (data point) we have
        % calculate the distance between simulation and exprimental data, taking measurement error into account
        temp = ((SimulationData(t,i)-ExperimentalData(t,i))/StandardDeviation(i))^2;
        % sum the distances (for every time point and for every metabolite)
        score = score + temp;
    end
end

end

