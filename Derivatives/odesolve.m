function sol = odesolve(par,wave,timepoint)



% --------------------------------------------------- %
%%------------- TIME SPAN OF THE SIMULATION------------%

EndTime=300; % length of the simulations
tspan=(0:1:EndTime);   % time points where the output is calculated


% INITIAL CONDITION FOR THE ODE MODEL
M0 = par(43); % 4.77*10^5;
Ma0 = 0;
Ba0 =0 ;
Bn0 =0 ;
B0 =300;
G_0= 100;
I0 =10;
D0 =par(44); %0;
tD0=par(45); %0;
E0 =0;
R_0 =0;
Em0=0;

y0=[M0, Ma0, Ba0, Bn0, B0, G_0, I0, D0 , tD0, E0, R_0, Em0];


% Solve ODE 

 options = odeset('Refine',1,'RelTol',1e-9);
 [t,y] = ode15s(@(t,y)T1D_ODE(t, y, par, wave),tspan,y0,options);

glucose = y(:,6); 

sol = glucose(timepoint);

end

