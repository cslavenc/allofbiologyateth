%SCCs_Humans	Returns the orientation of the SCCs in humans, relative to Reid's plane
% Provides the orientation of the canals, according to the results of 
% Della Santina et al,  "Orientation of Human Semicircular
% Canals Measured by Three-Dimensional Multi-planar CT Reconstruction.".
% J Assoc Res Otolaryngol 6(3): 191-206. 
%
% The orientation of the vectors indicates the direction of stimulation of
% the corresponding canal.
%
%	Call: Canals = SCCs_Humans();
%
%	ThH, April 2018
%	Ver 2.0
%*****************************************************************
function CanalInfo = SCCs_Humans()

Canals(1).side = 'right';
Canals(1).rows = {'horizontal canal'; 'anterior canal'; 'posterior canal'};
Canals(1).orientation = [0.32269, -0.03837, -0.94573; 
         0.58930,  0.78839,  0.17655;
         0.69432, -0.66693,  0.27042];
Canals(2).side = 'left';
Canals(2).rows = {'hor'; 'ant'; 'post'};
Canals(2).orientation = [-0.32269, -0.03837, 0.94573; 
         -0.58930,  0.78839,  -0.17655;
         -0.69432, -0.66693,  -0.27042];

% Normalize the canal-vectors (only a tiny correction):
for i = 1:2
    for j = 1:3
        Canals(i).orientation(j,:) = ...
            Canals(i).orientation(j,:) / norm( Canals(i).orientation(j,:) );
    end
end

CanalInfo = Canals;


