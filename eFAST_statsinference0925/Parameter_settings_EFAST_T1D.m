% This file is to set up max/min and baseline values for model parameters.
% Using U-subsetparameters from Parameter report. 
% PARAMETER INITIALIZATION
% set up max and mix matrices of model' parameters 



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
  

%------------- Estimated Parameters ------- % 
% minimum values
pmin=[
1      % sE 
10   % sR
1000   %Dss
0.001   %aEm
0.01   %eta_basal
0.01   %alpha_e
21      %beta_e
0.1 % fms 
0.1 % fmas
48000 % J 
0.4 % k 
0.01 % b 
0.07 %c 
1e-8 % e1
1e-8 % e2
0.02 % alpha_B
1/62 % deltaB
81 % Ghb 
500 % R0 
0.1 % G0 
0.1 % SI 
30 % sigmaI
460 % deltaI 
sqrt(2e2) % GI 
0.1 % Qpanc 
1e-6 % bDE
1e-6 % bIR
0.1 % aE
0.1 % aR
100 % Tnaive 
10 % bp
1e-3 % ram
1e2 % thetaD
0.5 % d
1e-4 % bDE
1e-4 % bR
0.01 % mu_BP: dont use
0.1 % mu_D
5e-8 % fD  
3e-7 %ftD  
1e-6 %muE
1e-6 % muR
% % 10^4%M0 
% % 1e4%D0 
% % 1e4%tD0
 0 % dummy
 ];
% % 
% % maximum values
 
pmax=[
 100      % sE 
 100   % sR
1e7   %Dss
0.1   %aE
0.03   %eta_basal
0.5   %alpha_e
30      %beta_e
2 % fms 
2 % fmasS
50000 % J 
1 % k 
0.1 % b 
0.25 %c 
1e-6 % e1
1e-6 %e2
0.05 % alpha_B
1/58 % deltaB
100 % Ghb 
1000 % R0 
2 % G0 
1 % SI 
50 % sigmaI
576 % deltaI 
sqrt(2e4) % GI 
0.5 % Qpanc 
1e-5 % bDE
1e-5 % bR 
0.5 % aE
0.5 % aR
500 % Tnaive 
90 % bp
1.5 % ram
1e5 % thetaD
1 % d 
1e-1 % bE
1e-1 % bR
1% mu_BP
1 % mu_D
5e-7 % fD
5e-6 %ftD
1e-5 % muE
1e-5 % muR
% 10^6%M0 
% 1e5%D0 
% 1e5%tD0 
10 % dummy
];

% 
% Parameter Labels 
Parameter_var={'sE', 'sR','D_{ss}','a_{Em}','\eta_{basal}','\alpha_e','\beta_e',...
    'f_m', 'f_{ma}','J','k','b','c','e_1','e_2','\alpha_B','\delta_B','G_{hb}',...
    'R_0','G0','S_I','\sigma_I','\delta_I','GI','Q_{panc}',...
    'b_{DE}','b_{IR}','a_{E}','a_{R}','T_{naive}','b_{p}','r_{am}',...
    '\theta_D', 'd', 'b_{E}','b_{R}','\mu_{BP}','\mu_D',...
    'fD','ftD','mu_E','mu_R', 'dummy'
    };%,

%Parameter_var={'sE', 'sR','dummy'
%    };%,


% 


%---------- PARAMETER BASELINE VALUES


baseline =[
 1 %sE
36 %sR
10^5 %D_ss
0.01 %aEm 
0.01 %eta_basal
0.11 %alpha_eta
22 %beta_e
1 %fm
1 %fmas
5*10^4 %J =  cells ml^-1d^-1 : normal resting macrophage influx
0.4 %k = d^-1: Ma deactivation rate
0.09  %b = d^-1: recruitment rate of M by Ma
0.1 %c =  d^-1: macrophage egress rate
1*10^(-8) %e1= cell^-1d^-1: anti-crowding terms for macrophages
1*10^(-8) %e2
0.0334  %alpha_B = 
1/60  %delta_B = 
90  %Ghb = 
864  %R0      = mg per dl
1.44  %G0     = per day
.72  %SI      =  ml per muU per day
43.2  %sigmaI  = muU per ml per day per mg
432  %deltaI  = per day
sqrt(20000) %GI      = mg per dl
.194 %Qpanc =  ml
0.487e-5  %bDE=  ml/cell/day, per capita elimination rate of DC by CTL
0.487e-5    %bR=ml/cell/day, per capita elimination rate of iDC by Tregs
.1199     % aE = per day; BUT I DON'T THINK THIS CAN BE RIGHT!  [ESTIMATED, =ln(2)/(5.78 days)]
.1199  %aR
370   % T_naive = cells, number of naive cells contributing to primary clonal expansion
12       % bp = per day, maximal expansion factor of activated CTL
0.01      %ram =  per day, reversion rate of active CTL to memory CTL
2.12e5 %thetaD =  cells/ml;  Threshold in DC density in the spleen for half maximal proliferation rate of CTL [7.5e2,1.2e4]
0.5  % d    = d^(-1)  rate of apoptotic cell decay into a necrotic cell
10^(-3) %bE =  BSH distinguish activation rate for effector memory cells by DC
10^(-3) %bIR = BSH distinguish activation rate for Treg memore cell by iDC
0.1 % mu_BP
0.51 % mu_D
1.7101e-07 %fD
1.1899e-06 %ftD
0.01/5000 %muE
0.01/5000 %muR
%4.77*10^5 % M0
%0 %D0
%0 %tD0
% f2*DCtoM % fDs
% f2*tDCtoM %ftDs
 1 % dummy
];   




%--------- Save Parameter Table for checking purpose
% ID = (1:size(pmax,1))';
% Parameters_Name = Parameter_var';
% T = table(ID,Parameters_Name,baseline, pmin, pmax);
% writetable(T,'Parameters_Table.csv','Delimiter',',') ; 
% type 'Parameters_Table.csv';
% 

%-----------------  Variables Labels
y_var_label={'M','Ma','Ba','Bn','B','G','I','D','tD','E','R','Em'};


