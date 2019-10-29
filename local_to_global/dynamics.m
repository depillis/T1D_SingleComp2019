function dynamics( wave, LHS, rownum)

% user input: 
% LHS: LHS matrix 
% rownum: row index of LHS matrix that needs for simuluation 
% 
% % ---------------  Initial conditions --------------- %
% Ds0 = 0; tDs0 = 0; Es0= 0; Rs0=0; Ems0 =0; Db0= 0; tDb0 = 0; 
% Eb0=0; Rb0=0; Emb0= 0; Mb0= 4.77*10^5; B0 = 300; 
% Ba0= 0; Bn0=0; Dpanc0=0; tDpanc0=0; Epanc0=0;Rpanc0=0 ; Empanc0=0; 
% M0 = 0; Ma0=0; G_0=100; I0 = 10; 
% 
% IC = [Ds0, tDs0, Es0, Rs0, Emss0, Db0, tDb0, Eb0, Rb0, Emb0, Mb0, B0,...
%     Ba0, Bn0, Dpanc0, tDpanc0, Epanc0, Rpanc0, Empanc0, M0, Ma0, G_0, I0]; 

% --------------------------------------------------- %
%% TIME SPAN OF THE SIMULATION
EndTime=300; % length of the simulations
tspan=(0:1:EndTime);   % time points where the output is calculated


%------- Fixed parameters------------ %
%scale_factor = .0623; % works for scale factor between .0604 and .0635 (to that many sig figs)
B_conv = 2.59*10^5; % Units: cell/mg, Computed using the Maree value for density of cells in healthy pancreas and Topp value for mg beta cells in healthy pancreas
%DCtoM = 5.49 * 10^(-2);
%tDCtoM = 3.82 * 10^(-1);
Qspleen = 0.10; % ml
%-------------------------------------

par = parameters(LHS,rownum); % load a vector of parameter values 

sE = par(1);
sR = par(2);
D_ss = par(3);
aEm = par(4);
eta_basal = par(5);
alpha_eta = par(6);
beta_eta = par(7);

fM = par(8);
fMa = par(9);
% fMab = par(53);
% fMan = par(54);

J = par(10);
k = par(11);
b = par(12);
c = par(13);
e1 = par(14);
e2 = par(15);
alpha_B = par(16);
delta_B = par(17);
Ghb = par(18);
R0 = par(19);
G0 = par(20);
SI = par(21);
sigmaI = par(22);
deltaI = par(23);
GI = par(24);
Qpanc = par(25);
bDE = par(26);
bIR = par(27);
aE = par(28);
aR = par(29);
T_naive = par(30);
bp = par(31);
ram = par(32);
thetaD = par(33);
d = par(34);
bE = par(35);
bR = par(36);
mu_BP= par(37);
mu_D = par(38);
fD = par(39);
ftD = par(40);
muE = par(41);
muR = par(42);% did not use
%multicomp
% muB = par(43); % assign parameter values par(24:80)
% Qblood = par(44);
% mustarSB= par(45);
% munormalSB= par(46);
% muBSE = par(47);
% aI = par(48);
% aD = par(49);
% Bconv = par(50);
% Qspleen = par(51);
% thetashut = par(52);
% deltamu = munormalSB-mustarSB;


%^^^ changed value from Shtylla et al., using GW thesis ^^^;
%^ changed value from Shtylla et al., using GW thesis ^;
%^^^ kept value from Shtylla et al. ^^^;
%muD = par(65); % did not use 
%^^^ changed value from Shtylla et al., using GW thesis ^^^;
%muBS = par(80);% did not use 

% wave = 1;
% noWave = 0;

% INITIAL CONDITION FOR THE ODE MODEL
M0 = par(43); % 4.77*10^5;
Ma = 0;
Ba =0 ;
Bn =0 ;
B =300;
G= 100;
I =10;
D0 =par(44); %0;
tD0=par(45); %0;
E =0;
R =0;
Em=0;

y0=[M0, Ma, Ba, Bn, B, G, I, D0 , tD0, E, R, Em];

options = odeset('Refine',1,'RelTol',1e-9);
    [t,y] = ode15s(@(t,y)rhs(t, y, fM, fMa, wave),tspan,y0,options);
glucose = y(:,6); 
plot(t,glucose); hold on; 




return

    function dy = rhs(t, y ,f1t, f2t, wave)

    %An's modfication: index= index of LHS 
    dy = zeros(12,1);

    

    %Define state variables
    M = y(1); % cells/ml
    Ma = y(2); % cells/ml
    Ba = y(3); % cells/ml
    Bn = y(4); % cells/ml

    % Added state variables
    B = y(5); % mg
    G = y(6); % mg/dl
    I = y(7); % mu U

    D = y(8); % cells/ml
    tD = y(9); % cells/ml

    E = y(10); % cells/ml
    R = y(11); % cells/ml
    Em = y(12); % cells/ml

    % Compute the apoptotic wave
    W = wave*.1*B*exp(-((t-9)/9)^2); % Modified from Maree et al 2006



    % W=0; % For testing with no wave
    eta_vary=eta_basal+2*eta_basal*(1 + tanh(alpha_eta*(t - beta_eta*7)));



    %M: Resting macrophages
    dy(1) = J + (k+b)*Ma -c*M - f1t*M.*Ba - f1t*M.*Bn - e1*M.*(M+Ma);
    %Ma: Activated macrophages
    dy(2) = f1t*M.*Ba +...
        f1t*M.*Bn - k*Ma - e2*Ma.*(M+Ma);
    %Ba: Apoptotic beta cells
    dy(3) = W*B_conv/Qpanc + eta_vary*((sE*E)^2./(1+(sE*E)^2 + (sR*R)^2)).*B*B_conv/Qpanc ...
        - f1t*M.*Ba-f2t*Ma.*Ba - d*Ba ...
        + delta_B*B*B_conv/Qpanc - ftD*(D_ss-D).*Ba - fD*D.*Ba;
    %Bn: Necrotic beta cells
    dy(4) = d*Ba - f1t*M.*Bn ...
        - f2t*Ma.*Bn - ftD*(D_ss-D).*Bn - fD*D.*Bn;


    %B: Healthy beta cells

    dy(5) = (alpha_B*G.^2./(G.^2+Ghb^2)).*B - delta_B*B - W ...
             - eta_vary*((sE*E).^2./(1+(sE*E).^2+ (sR*R).^2)).*B; % modified saturation


    %G: Glucose
    dy(6) = R0 - (G0 + (SI*I)).*G;%G
    %I: Insulin
    dy(7) = sigmaI*(G.^2/(G.^2 + GI.^2))*B - deltaI*I;


    %D: Immunogenic DCs
    dy(8) = ftD*Bn.*(D_ss-D) - bDE*E.*D - mu_D*D;%
    %tD: Tolerogenic DCs
    dy(9) = ftD*(D_ss-tD-D)*Ba - mu_D*tD - ftD*Bn*tD - bIR*R.*tD;


    %E: Effector T cells
    dy(10) = aE*(T_naive/Qspleen - E)+ bp*(D.*E)./(thetaD + D)...
                - ram*E + bE*D.*Em - muE.*E*R;
    %R: Regulatory T cells
    dy(11) = aR*(T_naive/Qspleen - R) + bp*(tD.*R)./(thetaD + tD)...
                - ram*R + bR*tD.*Em - muR.*E.*R;
    %Em: Memory T cells
    dy(12) = ram*(E+R) - (aEm + bE*D + bR*tD).*Em;

        
     
    end

end

