function s = efast_ttest_mod(Si,rangeSi, Sti,rangeSti,time_points,alpha) % use rangeSi or ramgeSti from efast_sd


%Si=Si(:,time_points);
%Sti=Sti(:,time_points);
%rangeSi=rangeSi(:,time_points,:);
%rangeSti=rangeSti(:,time_points,:);
%Si_struct

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
function pairwise_ttest
input: matrix of sensitivity indices Si(# parameters,# search curves)
output: square matrix of p-values, comparing each parameter
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SAefast_struct=struct;

[NR,output,k]=size(rangeSi); %record k number of parameters, NR number of search curves

SAefast_struct.Si=Si;
SAefast_struct.rangeSi=rangeSi;
SAefast_struct.Sti=Sti;
SAefast_struct.rangeSti=rangeSti;


for s=1:length(time_points)
    z=['time = ',num2str(time_points(s)/7),'th week']
    %[z y_var_label(u)]

    %% Compare Si or STi of parameter j with the dummy
    for i=1:k-1
        %% Si
        [rangeSi(:,s,i) rangeSi(:,s,k)];
        [squeeze(rangeSi(:,s,i)) squeeze(rangeSi(:,s,k))];
        
        % sample mean of Si for each parameter and dummy parameter
        [mean(squeeze(rangeSi(:,s,i))) mean(squeeze(rangeSi(:,s,k)))];
        
        % Apply student t-test to compare sample mean 
        [a,p_Si(s,i)]=ttest2(squeeze(rangeSi(:,s,i)),...
            squeeze(rangeSi(:,s,k)),alpha,'right','unequal');
       
        %% Sti
        [rangeSti(:,s,i) rangeSti(:,s,k)];
        [squeeze(rangeSti(:,s,i)) squeeze(rangeSti(:,s,k))];
        
        % sample mean of Si for each parameter and dummy parameter
        [mean(squeeze(rangeSti(:,s,i))) mean(squeeze(rangeSti(:,s,k)))];
        
        % Apply student t-test to compare sample mean 
        [a,p_Sti(s,i)]=ttest2(squeeze(rangeSti(:,s,i)),...
            squeeze(rangeSti(:,s,k)),alpha,'right','unequal');
        
%         [rangeSti(i,s,:,u) rangeSti(k,s,:,u)];
%         [squeeze(rangeSti(i,s,:,u)) squeeze(rangeSti(k,s,:,u))];
%         [mean(squeeze(rangeSti(i,s,:,u))) mean(squeeze(rangeSti(k,s,:,u)))];
%         [a,p_Sti(i,s,u)]=ttest2(squeeze(rangeSti(i,s,:,u)),squeeze(rangeSti(k,s,:,u)),alpha,'right','unequal');
    end % for i
    
    SAefast_struct.p_Si(:,:,s)=p_Si(s,:);
    SAefast_struct.p_Sti(:,:,s)=p_Sti(s,:);
end % for t

    
    s=SAefast_struct;
%     
% efast_var;
% Si_out=squeeze(s.Si(:,:))';
% p_Si_out=squeeze(s.p_Si(:,:,:))';
% 
% %% To display Sti and p-value
% Sti_out=squeeze(s.Sti(:,:))';
% p_Sti_out=squeeze(s.p_Sti(:,:,:))';