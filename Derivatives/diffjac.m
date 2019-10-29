
    
function [jac, jacrel] = diffjac(x,f,f0,time)
% Compute a forward difference dense Jacobian f'(x), return lu factors.
%
% uses dirder
%
% C. T. Kelley, April 1, 2003
%
% This code comes with no guarantee or warranty of any kind.
%
%
% inputs:
%          x, f = point and function
%          f0   = f(x), preevaluated

n = length(x); %different between senseq and senseq_ic
jac = zeros(length(f0), n);
jacrel = zeros(length(f0), n);

for j = 1:n
    zz = zeros(n,1);
    zz(j) = 1;
    [jac(:,j), jacrel(:,j)] = dirder(x,zz,f,f0,time);
end