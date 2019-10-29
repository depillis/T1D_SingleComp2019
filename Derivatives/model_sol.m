%--------------------------------------------------------------------------
% N. Tania (May 30, 2018)
%
%Solve the ODE using the given parameters (pars) and initial conditions
%(Init) at the given points (xdata)

%Output:
% sol: solution matrix to the ODE system 
% rout: only time series data of species of interest 
% flagg: numerical flag, either 0 (no error) or 1(otherwise)
%--------------------------------------------------------------------------

function [sol,rout,flagg] = model_sol(pars,x)

global ODE_TOL 

opts = odeset('RelTol',ODE_TOL, 'AbsTol',ODE_TOL);

%% run to steady state first, interrupt integration if it's taking too long
flagg = 0; % default value for flagg



% INITIAL CONDITION FOR THE ODE MODEL
M0 = 4.77*10^5;
Ma0 = 0;
Ba0 =0 ;
Bn0 =0 ;
B0 =300;
G_0= 100;
I0 =10;
D0 =0;
tD0=0;
E0 =0;
R_0 =0;
Em0=0;

Init=[M0, Ma0, Ba0, Bn0, B0, G_0, I0, D0 , tD0, E0, R_0, Em0];


try % try solve ode 
    [t,sol] = ode15s(@(t,y)T1D_ODE(t,y,pars(1:42)),x,Init,opts);
catch 
    disp(lasterr) % display error message then assign variable flagg=1
            % Note: lasterr will be removed in a future version. 
            % You can obtain information about any error 
            % that has been generated by catching an MException. 
            % See Capture Information About Exceptions 
            % in the Programming Fundamentals documentation.
    flagg=1;            % numerical integration issue
end % if solve carefully, flagg remains 0

sol = sol';

if flagg == 0
 % output measures level of M protein
 rout = sol(6,:);
else
 sol = 0;
 rout = 0;
end


% Sensitivity wrt residual or scaled residual
%rout = (sol(2,:)' - ydata);
%rout = (sol(2,:)' - ydata)/mean(ydata);
