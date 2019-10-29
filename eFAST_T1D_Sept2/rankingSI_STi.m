function rankingSI_STi(filename, num_var,outcomeindex)

% filename= model_efast.mat from model_efast_T1D routine 
% num_var =1 number of outcome model, ususally 1 bc we only
        % interested in glucose signal 
% oucomeindex = 1 % model outcome index. 
        % in the case we run a full model than we need to specify 
        % the model outcome that we want to see Si and Sti for 
        
% Ex: rankingSI_STi('Model_efast_all_Jul10.mat', 1, 1)
load(filename);
%Parameter_settings_EFAST_T1D;

Parameter_settings_EFAST_T1D;
K = size(pmax,1); % # of input factors (parameters varied) + dummy parameter


%% INPUT
NR = 30; %: no. of search curves - RESAMPLING
NS = 65; % # of samples per search curve
wantedN=NS*K*NR; % wanted no. of sample points

MI = 4; %: maximum number of fourier coefficients
        % that may be retained in calculating the partial
        % variances without interferences between the
        % assigned frequencies

% Computation of the frequency for the group
% of interest OMi and the # of sample points NS (here N=NS)

OMi = floor(((wantedN/NR)-1)/(2*MI)/K);%always equal to 8 
NS = 2*MI*OMi+1;

time_points=[70 273]; % time points of interest in days



y_var= num_var; % number of model outcomes that we are interested 
           % in doing sensitivity analysi 

% CALCULATE Si AND STi for each resample (1,2,...,NR) [ranges]
[Si,Sti,rangeSi,rangeSti] = efast_sd(Y,OMi,MI,time_points,1:y_var);


% T-test on Si and STi for Viral load (variable 4)
s_T1D = efast_ttest(Si,rangeSi,Sti,rangeSti,1:length(time_points),...
    Parameter_var,y_var,y_var_label,0.05);

% Table for Si 
u= outcomeindex; % model outcome index
id = (1:size(pmax))';
%---------- Si week 10 

SI_wk10 = s_T1D.Si(:,1,u);
pvalues_wk10 = [s_T1D.p_Si(:,:,1,u);NaN];
tblwk10 = table(id, Parameter_var',SI_wk10,pvalues_wk10);
tblwk10= sortrows(tblwk10,'pvalues_wk10');

%----------- Plot sorted Si week 10 by p-values

%only extract variables with p-values < 0.05
T_wk10 = tblwk10(tblwk10.pvalues_wk10<0.05,:);
T_wk10 = sortrows(T_wk10,'SI_wk10','descend');
n_T_wk10 = size(T_wk10.SI_wk10,1);

figure;
    bar(T_wk10.SI_wk10,'blue');
    xticks(1:1:n_T_wk10);
    set(gca,'xticklabel',T_wk10.id, 'FontSize',15);
    legend('Week 10')
    title({'First order sensitivity index week 10', ' p-value <0.05'})
    
%------------- Si week 39

SI_wk39 = s_T1D.Si(:,2,u);
pvalues_wk39 = [s_T1D.p_Si(:,:,2,u);NaN];
tblwk39 = table(id, Parameter_var',SI_wk39,pvalues_wk39);
tblwk39 = sortrows(tblwk39,'pvalues_wk39');

%----------- Plot sorted Si week 39 by p-values
%only extract variables with p-values < 0.05
T_wk39 = tblwk39(tblwk39.pvalues_wk39<0.05,:);
T_wk39 = sortrows(T_wk39, 'SI_wk39','descend');
n_T_wk39 = size(T_wk39.SI_wk39,1);

figure;
    bar(T_wk39.SI_wk39,'red');
        xticks(1:1:n_T_wk39);
    set(gca,'xticklabel',T_wk39.id,'FontSize',15);
    legend('Week 39')
    title({'First order sensitivity index week 39','pvalues<0.05'})

%---------- Table for Sti for week 10 

STI_wk10 = s_T1D.Sti(:,1,u);
pvalues_wk10 = [s_T1D.p_Sti(:,:,1,u);NaN];
tblwk10 = table(id, Parameter_var',STI_wk10,pvalues_wk10);
tblwk10= sortrows(tblwk10,'pvalues_wk10');

%----------- Plot sorted Sti week 10 by p-values
%only extract variables with p-values < 0.05
T_wk10 = tblwk10(tblwk10.pvalues_wk10<0.05,:);
T_wk10 = sortrows(T_wk10,'STI_wk10','descend');
n_T_wk10 = size(T_wk10.STI_wk10,1);


figure;
    bar(T_wk10.STI_wk10,'blue');
    xticks(1:1:n_T_wk10);
    set(gca,'xticklabel',T_wk10.id, 'FontSize',15);
    legend('Week 10')
    title({'Total order sensitivity index week 10', ' p-value <0.05'})
    
%------------- Sti week 39

STI_wk39 = s_T1D.Sti(:,2,u);
pvalues_wk39 = [s_T1D.p_Si(:,:,2,u);NaN];
tblwk39 = table(id, Parameter_var', STI_wk39,pvalues_wk39);
tblwk39 = sortrows(tblwk39,'pvalues_wk39');

%----------- Plot sorted Si week 39 by p-values

%only extract variables with p-values < 0.05
T_wk39 = tblwk39(tblwk39.pvalues_wk39<0.05,:);
T_wk39 = sortrows(T_wk39,'STI_wk39','descend');
n_T_wk39 = size(T_wk39.STI_wk39,1);

figure;
    bar(T_wk39.STI_wk39,'red');
    xticks(1:1:n_T_wk39);
    set(gca,'xticklabel',T_wk39.id, 'FontSize',15);
    legend('Week 39')
    title({'Total order sensitivity index week 39', ' p-value <0.05'})
end
    
    
% Parameters_Name = Parameter_var';
% T = table(id,Parameters_Name, pmax, pmin);




