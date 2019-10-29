%% Load efast Parameters setting
Parameter_settings_EFAST_T1D;
K = size(pmin,1); % number of parameters 
time_points = 280; 
type ='Sti';
alpha =0.05;
id = 1:K;

% run efast for an initial NR 
 NR = 50; 
[Si, Sti, rangeSi, rangeSti] = Model_efast_T1D_mod(NR,pmin,pmax);

save main.mat
% 
% % October 2nd, 2019
% % we dont know yet how to assign value of NR. 
% % should we do NR = 5, 6, or ... 30 or 50 etc
% 
% %option1: starting with some NR = 5 then increment by 1
% %           stop when the number of significant values settle down 
% % we will simulate efast for NR = 50 then then plot the number of
% % significant parameters on the y-axis to see the trend 
% 
% 
n_tab = zeros(1,NR);
for i =2: 100
   %% Statistical inference test student t-test with alpha = 0.05
 s_T1D = efast_ttest_mod(rangeSi(1:i,:), rangeSti(1:i,:),0.05);
 [sorttab, n_tab(i)] = post_process_data(s_T1D,type,0.05);
end

figure;
plot(n_tab,'*')
axis([0 100 0 43])


% %% Save data
% %writetable(sorttab,'efast_resultsOct7.csv','Delimiter',',');
% % 
figure; 
bar(sorttab.Sens)
xticks(1:1:size(sorttab,1)); 
ylabel('Total order sensitivity index')
title('eFAST')
set(gca,'xticklabel', sorttab.id, 'fontsize',20)
% 
 
 
%stopping criteria
% compare norm(dist) for 2 consecutive NR 
% save distribution of parameter for meeting and the final distribution

% try for example 

%save main

% redo eFAST algorithm for only 1 more time 
%[Si_new, Sti_new, rangeSi_new, rangeSti_new] = Model_efast_T1D_mod(1,pmin,pmax);



%update NR 
%NR = NR+1; 

%concatenate rangeSi_new and rangeSti_new to rangeSi and rangeSti structure
% for i=1:K
%     rangeSi(NR,:,i) = rangeSi_new(:,:,i); 
%     rangeSTi(NR,:,i) = rangeSi_new(:,:,i); 
% end 

% Statistical inference test student t-test with alpha = 0.05
% s_T1D = efast_ttest_mod(Si,rangeSi, Sti,rangeSti,time_points,0.05);
% [sorttab, n_tab] = post_process_data(s_T1D,type);
 
 
% post processing data: collect subset of significant parameters
% users has 2 options to post process either Si (first order sensitivity )
% or Sti (total order sensitivity) index
% 
% [sorttab, n_tab] = post_process_data(s_T1D,type);
% writetable(sorttab,'efast_results1.csv','Delimiter',',');


% % update NR by 1 then re-run efast
%NR = NR + 1; 


% 
% for i=1:K % Loop over k parameters (input factors)
%     % i=# of replications (or blocks)
%     % Algorithm for selecting the set of frequencies.
%     % OMci(i), i=1:k-1, contains the set of frequencies
%     % to be used by the complementary group.
%     
% 
% %% 
%     OMci = SETFREQ(K,OMi/2/MI,i); 
%     OM = [OMci(1:i-1) OMi OMci(i:K-1)];
%      
%     
%     %Allocation for variance computation 
%      Vi = zeros(1,length(time_points));
%      Vci = zeros(1,length(time_points));
%      V = zeros(1,length(time_points));
%         
%     % Loop over the NR search curves.
%         
%         % Create sampling matrix 
%         mat = eFAST_sampling(K,NS,pmax,pmin,OM);
%         
%         %allocate glucose matrix 
%         Y = zeros(NS, length(time_points));
%         
%         % Simulate dynamics model for glucose level
%         %parfor run_num=1:NS 
%         for run_num=1:NS 
%           [i run_num 1]
%            Y(run_num,:)=model_solver(mat,run_num, wave, time_points);        
%         end %run_num=1:NS
%     
%         
%         % Compute variance        
%         for u= 1:length(time_points)
%             [Vci(1,u), Vi(1,u), V(1,u)] = compute_variance(Y(:,u),OMi,MI);          
%         end       
%         
%         
%         % Compute average Sensitivity indices 
%         % from all the resampling search curve
% 
% %         
%         % Compute sensitivity indices for each search curve 
%         rangeSi(NR,:,i) = Vi./V;
%         rangeSti(NR,:,i) = 1-(Vci./V);
%         
% end % i=1:k
% 
% 
% %An's note: Si did not get updated. 
% %update efast results with new NR 
%  s_T1D = efast_ttest_mod(Si,rangeSi, Sti,rangeSti,time_points,0.05);
%  
%  %calculate sensitivity indices
% [sorttab2, n_tab2] = post_process_data(s_T1D,'Sti');
% 
% %compare between 2 table sorttab and sorttab2. 
% % Find all the element that is in sorttab but not in sorttab2 
% %dif= subset of those element 
% %idx is the index such that sorttab(idx) = dif
% [dif, idx] = setdiff(sorttab(:,2),sorttab2(:,2));
% 
% %if the idx = 0 then the 2 sets are the same, quit 
% % if they are not the same then increase NR. 
% 
% if idx ~= 0
%     %repeat this process 
%     sorttab = sorttab2;
%     NR = NR+1 ;
%     
%     parfor i=1:K % Loop over k parameters (input factors)
%         % i=# of replications (or blocks)
%         % Algorithm for selecting the set of frequencies.
%         % OMci(i), i=1:k-1, contains the set of frequencies
%         % to be used by the complementary group.
% 
% 
%     %% 
%         OMci = SETFREQ(K,OMi/2/MI,i); 
%         OM = [OMci(1:i-1) OMi OMci(i:K-1)];
% 
% 
%         %Allocation for variance computation 
%          Vi = zeros(1,length(time_points));
%          Vci = zeros(1,length(time_points));
%          V = zeros(1,length(time_points));
% 
%         % Loop over the NR search curves.
% 
%             % Create sampling matrix 
%             mat = eFAST_sampling(K,NS,pmax,pmin,OM);
% 
%             %allocate glucose matrix 
%             Y = zeros(NS, length(time_points));
% 
%             % Simulate dynamics model for glucose level
%             for run_num=1:NS 
%               [i run_num 1]
%                Y(run_num,:)=model_solver(mat,run_num, wave, time_points);        
%             end %run_num=1:NS
% 
% 
%             % Compute variance        
%             for u= 1:length(time_points)
%                 [Vci(1,u), Vi(1,u), V(1,u)] = compute_variance(Y(:,u),OMi,MI);          
%             end       
% 
% 
%             % Compute average Sensitivity indices 
%             % from all the resampling search curve
% 
%     %         
%             % Compute sensitivity indices for each search curve 
%             rangeSi(NR,:,i) = Vi./V;
%             rangeSti(NR,:,i) = 1-(Vci./V);
% 
%     end % i=1:k
% 
% %An's note: Si did not get updated. 
% %update efast results with new NR 
%  s_T1D = efast_ttest_mod(Si,rangeSi, Sti,rangeSti,time_points,0.05);
%  
% %calculate sensitivity indices
% [sorttab2, n_tab2] = post_process_data(s_T1D,'Sti');
% %compare between 2 table sorttab and sorttab2. 
% [dif, idx] = setdiff(sorttab(:,2),sorttab2(:,2));
% end 
% 
% save s_T1D

% 
% Si = squeeze(mean(rangeSi)); 
% Si = Si(1:end-1); 
% 
% %update Si 
% sorttab2.SI = Si;





    
