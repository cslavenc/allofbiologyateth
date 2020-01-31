function [x,fval]=ToyFBA_exercise_solution()
%% This function contains different variables that you need either to fill or modify in order to perform the tasks in the exercise. Read carefully all the comments.
%Usage--> After modifying the m file function, save it and type in
%command window: [x,fval]=ToyFBA();
%x is the distribution of fluxes and fval the value of the optimization. Read carefully the output comments.
%The actual optimization algorithm used in this tutorial is based on a built-in function of matlab called fmincon. Type help fmincon
%or doc fmincon in your  matlab command window to get more information. It
%is not important that you understand linear optimization but the basic of
%how this function can be used (e.g. inputs/outputs)


%% Stoichiometric matrix.
%Insert here the stoichiometric matrix of your model
S=[1	-1	-1	0	0	0	0	0	0
0	1	0	-1	0	-2	0	0	0
0	0	1	0	0	1	-1	0	0
0	0	0	2	0	0	1	-1	0
0	0	0	-1	1	0	0	0	0
0	0	0	0	0	1	0	0	-1
] ;

%% Set boundaries of the flux 
% If not asked otherwise the bound should be
%1000 for the upper bound and 0/-1000 for the lower bound in non-reversible and reversible reactions respectively.
lb=[0;0;0;0;0;0;0;0;0];

%% depending on the question
ub=[10;1000;1000;1000;10;1000;1000;1000;1000];
ub=[10;1000;1000;1000;0;1000;1000;1000;1000];
ub=[10;1000;0;1000;0;1000;1000;1000;1000];
ub=[10;1000;1000;1000;5;1000;1000;1000;1000];

%% Optmization. We use here the fmincon function of matlab. Please go through the help in order to understand inputs and outputs
% For simplicity we set the starting point to a zero vector.

x0=zeros(length(ub),1);

 [x,fval] = fmincon(@obj,x0,[],[],S,zeros(size(S,1),1),lb,ub);
end

%% Optimization function
%This function define what you want to minimize/maximize. In our case wich flux (or linear combinations of fluxes). For example to
%minimize flux through the Yth reaction type f=x(y). To maximize f=-x(y).

function f = obj(x)
f = -x(8);
end



