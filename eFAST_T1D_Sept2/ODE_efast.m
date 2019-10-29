%% This ODE represents the HIV model in Section 4.2 Marino 2008 Pg 188
function dy = ODE_efast(t,y, wave,LHS,run_num)

%% Input: X- LHS matrix where the order of stored parameter values
% is stated in parameter_setting_efast
dy = zeros(12,1);

par = LHS(run_num,:); %load parameter values from LHS matrix
ParameterseFAST; % load parameter values to the assgned names 

%% System of ODE 



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