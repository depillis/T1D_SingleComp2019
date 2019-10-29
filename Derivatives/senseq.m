%--------------------------------------------------------------------------
% N. Tania (May 30, 2018)
%
% Computes the sensitivity matrix dy/dpars and 
% the relative sensitivity matrix dy/dlog(pars) = dy/dpars*pars, 
%
% senseq measures sensitivity relative to parameter
% senseq_ic measures sensitivity relative to initial conditions
%
% The code below are modified from
%   https://web.math.ncsu.edu/cdg/supplemental-material/
%--------------------------------------------------------------------------

function [sens,sensrel, flagg, y, sol] = senseq(pars,x)

[sol,y,flagg] = model_sol(pars,x); %solve ODE model for the given  
                    % parameters and initial conditions
                    % sol: solution of the ODE system (matrix)
                    % y: model output of interest (vector)
                    % flagg: flag numerical error. Either 0(no error) or 1(otherwise)
                 
%Depending on form of y, the sensitivity matrix could be dymodel/dpars or 
%dr/dpars where r = ymodel - ydata

% flagg is to catch integration failures
if flagg == 0
[sens, sensrel] = diffjac(pars,@model_sol,y,x); %possible parallel here
else
 sens = 0; senrel=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






