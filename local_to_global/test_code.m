LHS = csvread('LHS.csv'); 

for i = 10: 50
    dynamics(1,LHS,i) 
end


%--------Need to have this file in order to run parfor------------ %
Parameter_var={'sE','sR','D_ss','aEm','eta_basal','alpha_eta','beta_eta',...
    'fM','fMa','J','k','b','c','e1','e2','alpha_B','delta_B','Ghb','R0',...
    'G0','SI',...
    'sigmaI','deltaI','GI','Qpanc','bDE','bIR','aE','aR','T_naive','bp','ram',...
    'thetaD',...
     'd','bE','bR','mu_BP','mu_D','fD','ftD','muE','muR','M0','D0','tD0'};
 %-----------------------------------------------------------------%
 
 dynamics_percent(Parameter_var(45),1,LHS,1)