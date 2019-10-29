Parameter_settings_LHS;
%------- Fixed parameters------------ %
scale_factor = .0623; % works for scale factor between .0604 and .0635 (to that many sig figs)
B_conv = 2.59*10^5; % Units: cell/mg, Computed using the Maree value for density of cells in healthy pancreas and Topp value for mg beta cells in healthy pancreas
DCtoM = 5.49 * 10^(-2);
tDCtoM = 3.82 * 10^(-1);
Qspleen = 0.10; % ml
%-------------------------------------


sE = par(1);
sR = par(2);
D_ss = par(3);%baseline(3) ; %
aEm = par(4);% baseline(4); %
eta_basal = par(5);% baseline(5); %
alpha_eta = par(6);% baseline(6); %
beta_eta = par(7);% baseline(7); %

f1s = par(8); %baseline(8); % need to multiply by scale factor 
f2s = par(9);% baseline(9); %
 f1t  = scale_factor*f1s*10^(-5); %ml cell^-1d^-1 %wt basal phagocytosis rate per M
 f2t  = scale_factor*f2s*10^(-5);%ml cell^-1d^-1 %wt activated phagocytosis rate per Ma

J = par(10);% baseline(10); %
k = par(11);% baseline(11); %
b = par(12); %baseline(12); %
c = par(13); % baseline(13); %
e1 = par(14);% baseline(14); %
e2 = par(15);%baseline(15); %
alpha_B = par(16); %baseline(16); %
delta_B = par(17);%baseline(17); %
Ghb = par(17);%baseline(18); %x
R0 = par(19);%baseline(19); %
G0 = par(20); %baseline(20); %
SI = par(21); % baseline(21); 
sigmaI = par(22); % baseline(22); %
deltaI = par(23);% baseline(23); %
GI = par(24);% baseline(24); %
Qpanc = par(25);% baseline(25); %
bDE =par(26);% baseline(26); %
bIR = baseline(27); %
aE = par(27);%baseline(28); %par(28);
aR = par(29);% baseline(29); %
T_naive = par(30);% baseline(30); %
bp = par(31);% baseline(31); %
ram = par(32);% baseline(32); %
thetaD = par(33); %baseline(33); %
d = par(34);%baseline(34); %
bE = par(35);% baseline(35); %
bR = par(36);% baseline(36);%
mu_BP= par(37); % baseline(37); %
mu_D = par(38);% baseline(38); %
fD = par(39);% baseline(39); %
ftD = par(40);%baseline(40); %
muE = par(41);%baseline(41); %
muR = par(42);%baseline(42); % did not use


