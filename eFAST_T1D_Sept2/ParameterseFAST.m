% setappdata and getappdata functions provide a convenient way to 
% share data between callbacks or between separate User Interface

%May 23: ParametersLHS is the file specifically used for this routine
% it will update fms and fmas in the LHS routine 



%------- Fixed parameters------------ %
scale_factor = .0623; % works for scale factor between .0604 and .0635 (to that many sig figs)
B_conv = 2.59*10^5; % Units: cell/mg, Computed using the Maree value for density of cells in healthy pancreas and Topp value for mg beta cells in healthy pancreas
DCtoM = 5.49 * 10^(-2);
tDCtoM = 3.82 * 10^(-1);
Qspleen = 0.10; % ml

% Clearance rates for BalbC and NOD mouse are our control values

%BalbC parameters: 
 f1b = 2; f2b = 5;
  f1  = scale_factor*f1b*10^(-5); %ml cell^-1d^-1 %wt basal phagocytosis rate per M
  f2  = scale_factor*f2b*10^(-5);%ml cell^-1d^-1 %wt activated phagocytosis rate per Ma

%NOD parameters
 f1nod =1; f2nod = 1;
 f1n = scale_factor*f1nod*10^(-5); %ml cell^-1d^-1 %nod basal phagocytosis rate per M 
 f2n = scale_factor*f1nod*10^(-5); %ml cell^-1d^-1 % nod activated phagocytosis rate per Ma 
  

% An's modification:
% setappdata was set in the main executing file
% Parameter file use getappdata to call back the values assign in the main
% file. 


%---------- Re-ordering parameters
sE     = par(1); %saturation terms for effector killing
sR     = par(2); %control of trefs over effector killing
D_ss = par(3);
aEm = par(4);    % per day; death rate of memory CTL cells [ESTIMATED, =ln(2)/(69 days)]
eta_basal = par(5); %getappdata(0,'etabasal_var');
alpha_eta= par(6); %This value seems to control the jump slope
beta_eta=par(7);% This afects the time to sick

 f1s = par(8);
 f2s = par(9);
 f1t  = scale_factor*f1s*10^(-5); %ml cell^-1d^-1 %wt basal phagocytosis rate per M
 f2t  = scale_factor*f2s*10^(-5);%ml cell^-1d^-1 %wt activated phagocytosis rate per Ma

J = par(10); % cells ml^-1d^-1 : normal resting macrophage influx
k = par(11); %d^-1: Ma deactivation rate
b = par(12) ; %d^-1: recruitment rate of M by Ma
c = par(13); %d^-1: macrophage egress rate
e1= par(14); %cell^-1d^-1: anti-crowding terms for macrophages
e2= par(15);
alpha_B = par(16);
delta_B = par(17);
Ghb = par(18);
R0      = par(19); %mg per dl
G0     = par(20); %per day
SI      = par(21); % ml per muU per day
sigmaI  = par(22); %muU per ml per day per mg
deltaI  = par(23); %per day
GI      =par(24); %mg per dl
Qpanc = par(25); % ml
bDE = par(26);  % ml/cell/day, per capita elimination rate of DC by CTL
bIR = par(27);    %ml/cell/day, per capita elimination rate of iDC by Tregs
aE = par(28);     % per day; BUT I DONT THINK THIS CAN BE RIGHT!  [ESTIMATED, =ln(2)/(5.78 days)]
aR = par(29);
T_naive = par(30);   % cells, number of naive cells contributing to primary clonal expansion
bp = par(31);         % per day, maximal expansion factor of activated CTL
ram = par(32);      % per day, reversion rate of active CTL to memory CTL
thetaD = par(33); % cells/ml;  Threshold in DC density in the spleen for half maximal proliferation rate of CTL [7.5e2,1.2e4]
d    = par(34) ; % d^(-1)  rate of apoptotic cell decay into a necrotic cell
bE =  par(35); %BSH distinguish activbaEdadasdbation rate for effector memory cells by DC
bR =  par(36); %BSH distinguish activation rate for Treg memore cell by iDC
mu_BP = par(37);          % per day
mu_D = par(38);         % per day, original value


fD = par(39);
ftD = par(40);


muR = par(41) ;     %per day;  rate of CTL-Treg removal equal to death rate of memory CTL
muE = par(42);



 %% TIME SPAN OF THE SIMULATION
EndTime=600; % length of the simulations
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


