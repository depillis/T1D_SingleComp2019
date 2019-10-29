%% Post-Processing%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filter outliers

% manual inspections shown that all parameter sets below lead to numerical
% instabilities or non-convergence to a steady state solution
[idxx,idxy] = find(Rel_Norm2_store>1e4);
ifilter = unique(idxx);

% initialize stored arrays
SSstore(ifilter,:) = [];             % store steady state values     

% classical sensitivity
Norm2_store(ifilter,:) = [];   % norm of sensitivity matrix column
Isens_2(ifilter,:) = [];      % ordering of norm
Isens_SVD(ifilter,:) = [];    % binary sensitive/nonsensitive result from SVD/QR
SV_store(ifilter,:) = [];     % singular values
rankSens(ifilter,:) = [];           % rank of sensitvity matrix

% relative sensitivity
Rel_Norm2_store(ifilter,:) = [];
Rel_Isens_2(ifilter,:) = [];
Rel_Isens_SVD(ifilter,:) = [];
Rel_SV_store(ifilter,:) = [];
Rel_rankSens(ifilter,:) = [];
Rel_Sens_Group(ifilter,:) = [];

% fraction of trials with failed integration
Nsample = length(Norm2_store);

%% Sensitivity results

% average sensitivity index
Avg_Sens_Norm = mean(Rel_Norm2_store)';
[Avg_Sens_Norm, Rel_Order_Sens_Norm] = sortrows(Avg_Sens_Norm,'descend');

parname={'sE', 'sR','D_{ss}','a_{Em}','\eta_{basal}','\alpha_e','\beta_e',...
    'f_m', 'f_{ma}','J','k','b','c','e_1','e_2','\alpha_B','\delta_B','G_{hb}',...
    'R_0','G0','S_I','\sigma_I','\delta_I','GI','Q_{panc}',...
    'b_{DE}','b_{IR}','a_{E}','a_{R}','T_{naive}','b_{p}','r_{am}',...
    '\theta_D', 'd', 'b_{E}','b_{R}','\mu_{BP}','\mu_D',...
    'fD','ftD','mu_E','mu_R','dummy'};%,
 n_par = size(parname,2);

par_sort = parname(Rel_Order_Sens_Norm); % ordered parameter values

% figure 5
% boxplot of sensitivity index value
figure
boxplot(Rel_Norm2_store(:,Rel_Order_Sens_Norm));
set(gca, 'fontsize',20)
set(gca, 'XTickLabel',Rel_Order_Sens_Norm)
xlabel('Parameter Number')
ylabel('Sensitivity Index')

figure
plot(Avg_Sens_Norm,'*')
set(gca, 'fontsize',20)
set(gca, 'XTick',1:1:n_par,'XTickLabel',Rel_Order_Sens_Norm)
xlabel('Parameter Number')
ylabel('Sensitivity Index')

%%%%%%%%%%%%%%%%


%% Subset Selection - SVD/QR Results
 
% After each simulation, sensitivity matrix is computed
% SVD decomposition determines the number of sensitivity parameters
% QR decompostion ranks the sensitivity of the parameters 
% Rel_Sens_Group is a binary matrix size (LHSrow,npars) keeps track of 
% sensitivity parameters for each simulation 


Frac_Sens = mean(Rel_Sens_Group)';
[Frac_Sens, Frac_Sens_I] = sortrows(Frac_Sens,'descend');
par_sort_svd = parname(Frac_Sens_I);%parameter name vector

% figure 6A displays fraction of time parameters are considered to be
% sensitive 

figure
c=[0.301960796117783 0.745098054409027 0.933333337306976];
stem(1:n_par,Frac_Sens(1:n_par),'linewidth',2,'color',c,'MarkerSize',10,'MarkerEdgeColor',c,'MarkerFaceColor',c),
set(gca, 'XTick', [1,2:1:n_par])
set(gca, 'XTickLabel',Frac_Sens_I,'fontsize',15)
ylabel('Fraction of times considered sensitive', 'FontSize',20)
xlim([0.5 n_par])
ylim([0 1.05])


% figure 6B and C
% boxplot of singular values
% we discard any singular value that less than 1e-5
figure
boxplot(Rel_SV_store);
set(gca, 'YScale', 'log')
hold on
plot([0,n_par],[1e-5 1e-5],':','LineWidth',3 )
ylabel('Singular Values')
xlabel('Parameter Index')
set(gca, 'FontSize',20)


% histogram of number of sensitive parameters
% hist(Rel_rankSens,0.5:1:n_par+0.5)
[N,EDGES] = histcounts(Rel_rankSens,0.5:1:n_par+0.5);

figure % scale
stem(1:43, N(1:43)/Nsample, 'linewidth',2,'color','k')  
set(gca, 'XTick',1:1:n_par,'XTickLabel', 1:1:n_par,'fontsize',20)
ylabel('Fraction of trials')
xlabel('Parameter Index')
