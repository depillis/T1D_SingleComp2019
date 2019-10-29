% setappdata and getappdata functions provide a convenient way to 
% share data between callbacks or between separate User Interface

%May 23: ParametersLHS is the file specifically used for this routine
% it will update fms and fmas in the LHS routine 

Parameter_settings;

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
sE     = baseline(1); %saturation terms for effector killing
sR     = baseline(2); %control of trefs over effector killing
D_ss = baseline(3);
aEm = baseline(4);    % per day; death rate of memory CTL cells [ESTIMATED, =ln(2)/(69 days)]
eta_basal = getappdata(0,'etabasal_var'); %getappdata(0,'etabasal_var');
alpha_eta= baseline(6); %This value seems to control the jump slope
beta_eta=baseline(7);% This afects the time to sick

 f1s = getappdata(0,'fms_var');
 f2s = getappdata(0,'fmas_var');
 f1t  = scale_factor*f1s*10^(-5); %ml cell^-1d^-1 %wt basal phagocytosis rate per M
 f2t  = scale_factor*f2s*10^(-5);%ml cell^-1d^-1 %wt activated phagocytosis rate per Ma

J = baseline(10); % cells ml^-1d^-1 : normal resting macrophage influx
k = baseline(11); %d^-1: Ma deactivation rate
b = baseline(12) ; %d^-1: recruitment rate of M by Ma
c = baseline(13); %d^-1: macrophage egress rate
e1= baseline(14); %cell^-1d^-1: anti-crowding terms for macrophages
e2= baseline(15);
alpha_B = baseline(16);
delta_B = baseline(17);
Ghb = baseline(18);
R0      = baseline(19); %mg per dl
G0     = baseline(20); %per day
SI      = baseline(21); % ml per muU per day
sigmaI  = baseline(22); %muU per ml per day per mg
deltaI  = baseline(23); %per day
GI      =baseline(24); %mg per dl
Qpanc = baseline(25); % ml
bDE = baseline(26);  % ml/cell/day, per capita elimination rate of DC by CTL
bIR = baseline(27);    %ml/cell/day, per capita elimination rate of iDC by Tregs
aE = baseline(28);     % per day; BUT I DONT THINK THIS CAN BE RIGHT!  [ESTIMATED, =ln(2)/(5.78 days)]
aR = baseline(29);
T_naive = baseline(30);   % cells, number of naive cells contributing to primary clonal expansion
bp = baseline(31);         % per day, maximal expansion factor of activated CTL
ram = baseline(32);      % per day, reversion rate of active CTL to memory CTL
thetaD = baseline(33); % cells/ml;  Threshold in DC density in the spleen for half maximal proliferation rate of CTL [7.5e2,1.2e4]
d    = baseline(34) ; % d^(-1)  rate of apoptotic cell decay into a necrotic cell
bE =  baseline(35); %BSH distinguish activbaEdadasdbation rate for effector memory cells by DC
bR =  baseline(36); %BSH distinguish activation rate for Treg memore cell by iDC
mu_BP = baseline(37);          % per day
mu_D = baseline(38);         % per day, original value
fD = f2*DCtoM;
ftD = f2*tDCtoM;
mues_r = aEm/5000 ;     %per day;  rate of CTL-Treg removal equal to death rate of memory CTL
mues_e = aEm/5000;


