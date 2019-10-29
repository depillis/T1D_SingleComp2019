%--------------------------------------------------------------------------
% N. Tania (May 30, 2018)
%
%Computes the sensitivity matrix dy/dpars and 
% the relative sensitivity matrix dy/dlog(pars) = dy/dpars*pars, 
%
% senseq measures sensitivity relative to parameter
% senseq_ic measures sensitivity relative to initial conditions
%
% Original implementation of senseq are found in
%   https://web.math.ncsu.edu/cdg/supplemental-material/
%--------------------------------------------------------------------------

function [sens,sensrel,flagg, y, sol] = senseq_ic(pars,x,Init)

[sol,y,flagg] = model_sol(pars,x,Init);

%Depending on form of y, the sensitivity matrix could be dymodel/dpars or 
%dr/dpars where r = ymodel - ydata

% flagg is to catch integration failures
if flagg == 0
[sens, sensrel] = diffjac_ic(pars,@model_sol,y,x,Init);
else
 sens = 0; senrel=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

