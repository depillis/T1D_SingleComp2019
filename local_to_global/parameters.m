function parameters = parameters(LHS,rownum)
%Jul 26 An's modification
% Input: LHS matrix will update parameter values 

LHS = LHS(rownum, :); %extract the row of LHS matrix 

%==========================================================;
%Parameter values and definitions pulled from GW Thesis;
%==========================================================;

sE = LHS(1); %Relative impact of effector T cells on Beta cell death: ml/cells;
sR = LHS(2); %Relative impact of regulatory T cells on Beta cell death: ml/cells;
Dss = LHS(3); %Steady-state DC population: cells/ml;
aEm = LHS(4); %Death rate of memory T cells: 1/day
eta_basal = LHS(5); %Rate at which T cells eliminate Beta cells: 1/day;
alpha_eta = LHS(6);
beta_eta = LHS(7);
%fMb = LHS(8)*0.0623*(10^(-5)); %Rates macrophages engulf necrotic and apoptotic Beta cells; Balb/c mice: ml/cells/days;
fM = LHS(8)*0.0623*(10^(-5)); %Rates macrophages engulf necrotic and apoptotic Beta cells; NOD mice: ml/cells/day;
%fMab = 5*0.0623*(10^(-5)); %Activated phagocytosis rate per activated macrophage; Balb/c mice: ml/cells day;
fMa = LHS(9)*0.0623*(10^(-5)); %Activated phagocytosis rate per activated macrophage; NOD mice: ml/cells day;
J =LHS(10); %normal resting macrophage influx: cells / mL / day;
%J = 50000;
k =LHS(11); %Ma deactivation rate: 1/day;
b = LHS(12); %Recruitment rate of macrophages by activated macrophages: 1/day;
c = LHS(13); %macrophage egress rate; 1/day;
e1 = LHS(14); %Effect of crowding on macrophages: 1/cell day;
e2 = LHS(15); %Effect of crowding on active macrophages: 1/cell day;
alphaB = LHS(16); %Beta-cell growth rate; 1/day;
deltaB = LHS(17); %Beta-cell death rate: 1/day;
Ghb = LHS(18); %Glucose level of half-max Beta cell production: mg/dl;
R0 = LHS(19); %Basal rate of glucose production: mg/dl;
G0 = LHS(20); %Rate of glucose decay: 1/day;
SI =LHS(21); %Rate of glucose elimination via insulin: ml/microU/day;
sigmaI = LHS(22); %Maximum rate of insulin production by Beta cells: microU/ml/day/mg;
deltaI = LHS(23); %Rate of insulin decay: 1/day;
GI = LHS(24); %Glucose level of half-max insulin production: mg/dl;
Qpanc =LHS(25); %Volume of mouse pancreas: ml;
bDE = LHS(26); %Rate of elimination of DCs by effector T cells: ml/cells/day;
bIR = LHS(27); %Rate of elimination of tDCs by regulatory T cells: ml/cells/day;
aE = LHS(28); %rate of initial expansion of naive T-cells to effector T-cells: 1/day;
aR = LHS(29); %Rate of initial expression of naive T cells into regulatory T cells: 1/day;
Tnaive = LHS(30); %Density of naive T cells contributing to initial production of Teff and Treg in the spleen: cells/ml;
bP = LHS(31); %maximum expansion rate of effector T-cells due to DCs: 1/day;
ram =LHS(32); %Reversion rate of Teff and Treg cells to memory T cells: 1/day;
thetaD = LHS(33); %DC value for half-maximal effector T cell expansion: 1/day;
d = LHS(34); %Beta cell rate of necrosis: 1/day;
bE = LHS(35); %Activation rate of effector T cells from memory T cells: (ml*day)/cells
bR = LHS(36);%Activation rate for regulatory T cells from memory T cells: (ml*day)/cells
muBP= LHS(37);%emigration rate of DCs and T-cells from the blood to the pancreas: 1/day;
muPB =LHS(38); 
fD = LHS(39); %Rate DCs engulf Beta cells: ml/cell day;
ftD = LHS(40); %Rate native or tolerogenic DCs engulf Beta cells: ml/cells day;
muE =LHS(41); %rate of E removal due to competition: 1/day;
muR =LHS(42); %regulatory T-cell removal rate due to competition: 1/day;
M0 = LHS(43);
D0 =LHS(44); %0;
tD0=LHS(45);
% muB = LHS(43); %Dendritic cell emigration rate from blood to spleen: 1/day; Ludewig SD of 5.9/hour
% Qblood = LHS(44); %Volume of mouse blood compartment: ml;
% mustarSB= LHS(45); %CTL migration rate from the spleen to blood at equilibrium: 1/day;
% munormalSB=LHS(46); %normal CTL migration rate from spleen to blood: 1/day;
% muBSE = LHS(47); %T-cell emigration rate from blood to spleen: 1/day;
% aI = LHS(48); %Death rate of tolerogenic DCs in the spleen: 1/day;
% aD = LHS(49); %Death rate of Immunogenic DCs in the spleen: 1/day;
% Bconv = LHS(50); %Beta cells per miligram: cells/mg;
% Qspleen = LHS(51); %volume of mouse spleen: mL;
% thetashut = LHS(52);
% 
% deltamu = munormalSB - mustarSB; % [munormalSB - mustarSB]: 1/day;
% 

%================================;
% Parameters pulled from DePillis 2013;
%================================;
% DMax = 400; % (cells/hour)
% thetashut = 13; %Scaled threshold in DC density in the spleen for half-maximal transfer rate from spleen to blood: cells per mL;
% muBS = 2.832; %Transfer rate of DCs from blood to spleen 1/day
%========================================================;
%user defined variables;
%========================================================;


% Return parameters in appropriate matrix


parameters = [sE,sR,Dss,aEm,eta_basal,alpha_eta,beta_eta,...
    fM,fMa,J,k,b,c,e1,e2,alphaB,deltaB,Ghb,R0,G0,SI,...
    sigmaI,deltaI,GI,Qpanc,bDE,bIR,aE,aR,Tnaive,bP,ram,thetaD,...
     d,bE,bR,muBP,muPB,fD,ftD,muE,muR, M0, D0, tD0];
end 
%  ,muB,Qblood,mustarSB,...
%      munormalSB,muBSE,aI,aD,Bconv,Qspleen,thetashut];
   
