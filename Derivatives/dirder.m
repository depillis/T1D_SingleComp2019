
function [z, zrel] = dirder(x,w,f,f0,time)
% Compute a finite difference directional derivative.
% Approximate f'(x) w
% 
% C. T. Kelley, April 1, 2003
%
% This code comes with no guarantee or warranty of any kind.
%
% function z = dirder(x,w,f,f0)
%
% inputs:
%           x, w = point and direction
%           f = function
%           f0 = f(x), in nonlinear iterations
%                f(x) has usually been computed
%                before the call to dirder

% Hardwired difference increment.
%global DIFF_INC
ODE_TOL  = 1e-10;
DIFF_INC = sqrt(ODE_TOL);

epsnew = DIFF_INC;

n = length(x);

% scale the step
if norm(w) == 0
    z = zeros(n,1);
return
end

% Increment by epsnew = DIFF_INC

xs=(x*w)/norm(w); % why divide by norm(w)=1?
if xs ~= 0.d0
    epsnew=epsnew*max(abs(xs),1.d0)*sign(xs);
end
epsnew=epsnew/norm(w);

% del and f1 could share the same space if storage
% is more important than clarity.
% make sure the size matches


%update parameter vector by increasing the ith parameter by DIFF_INC
del = x+epsnew*w';

%suppress warning error due to numerical tolerance 
 warning ('off','all');
 
%solve T1D model with the new parameter values from del 
% pass model T1D_ODE here 
[sol, f1,flag]  = feval(f,del,time); % produce row vector while f0 is a column vector

 
% if there is some numerical warnings size f1 and f0 will not match
if length(f1) ~= length(f0)
    z=0;
    zrel =0;
else 
    z   = (f1 - f0)/epsnew;
    % %Relative sensitivity = change in glucose/epsilon
    zrel = z;
    zrel = zrel*x(w==1)./f0;
end
