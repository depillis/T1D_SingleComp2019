% First order and total effect indices for a given
% model computed with Extended Fourier Amplitude
% Sensitivity Test (EFAST).
% Andrea Saltelli, Stefano Tarantola and Karen Chan.
% 1999. % "A quantitative model-independent method for global
% sensitivity analysis of model output". % Technometrics 41:39-56

clear;
close all;

%% efast Parameters setting
Parameter_settings_EFAST_T1D;
K = size(pmax,1); % # of input factors (parameters varied) + dummy parameter


%% INPUT
NR = 5; %30; %: no. of search curves - RESAMPLING
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

if(NS*NR < 65)
    fprintf(['Error: sample size must be >= ' ...
    '65 per factor.\n']);
    return;
end

%% Wave 
wave = 1; 
time_points=[70 273]; % time points of interest in days 

% pre-allocation: glucose signal, Si, Sti, rangeSi, rangeSti
  Si = zeros(length(pmin), length(time_points)); 
  Sti = zeros(length(pmin),length(time_points)); 
  rangeSi = zeros(NR, length(time_points),length(pmin)); 
  rangeSti = zeros(NR, length(time_points),length(pmin)); 
  

parpool
tic
parfor i=1:K % Loop over k parameters (input factors)
    % i=# of replications (or blocks)
    % Algorithm for selecting the set of frequencies.
    % OMci(i), i=1:k-1, contains the set of frequencies
    % to be used by the complementary group.
    
    OMci = SETFREQ(K,OMi/2/MI,i); 
    % Frequency vector 
    OM = [OMci(1:i-1) OMi OMci(i:K-1)];
     
    
    %Allocation for variance computation 
%      AV = 0;
%      AVi = 0;
%      AVci = 0;  
     Vi = zeros(NR,length(time_points));
     Vci = zeros(NR,length(time_points));
     V = zeros(NR,length(time_points));
        
    % Loop over the NR search curves.
   for L=1:NR
        
        % Create sampling matrix 
        mat = eFAST_sampling(K,NS,pmax,pmin,OM);
        
        %allocate glucose matrix 
        Y = zeros(NS, length(time_points));
        
        % Simulate model
        for run_num=1:NS 
          [i run_num L]
           Y(run_num,:)=model_solver(mat,run_num, wave, time_points);        
        end %run_num=1:NS
    
        
        % Compute variance        
        for u= 1:length(time_points)
            [Vci(L,u), Vi(L,u), V(L,u)] = compute_variance(Y(:,u),OMi,MI);          
        end
        
    end % L=1:NR
        
        
        % Compute average Sensitivity indices 
        % from all the resampling search curve
        Si(i,:) = mean(Vi)./mean(V);
        Sti(i,:) = 1-(mean(Vci)./mean(V));
        
        % Compute sensitivity indices for each search curve 
        rangeSi(:,:,i) = Vi./V;
        rangeSti(:,:,i) = 1-(Vci./V);

end % i=1:k
toc

% Save average sensitivity indices Si and Sti
% save NR number of Si and Sti: rangeSi, rangeSti
save Si
save Sti
save rangeSi
save rangeSti 

% Statistical inference test
% student t-test. 
 s_T1D = efast_ttest_mod(Si,rangeSi, Sti,rangeSti,time_points,0.05);
 save s_T1D

% post processing data
%post_processing_data('s_T1D.mat')
