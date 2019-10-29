function s = efast_ttest_mod(rangeSi,rangeSti,alpha) % use rangeSi or ramgeSti from efast_sd


%Si= vector 1xK average SI 
%Sti=vector 1xK average STi
%rangeSi=rangeSi(NR, K); matrix whose row is NR and column is parameters
%rangeSti=rangeSti(NR,K);matrix whose row is NR and column is parameters

SAefast_struct=struct;

[NR,k]=size(rangeSi); %record k number of parameters, NR number of search curves

SAefast_struct.Si=mean(rangeSi); %store average
SAefast_struct.rangeSi=rangeSi; %store all Si values
SAefast_struct.Sti=mean(rangeSti);
SAefast_struct.rangeSti=rangeSti;


% for s=1:length(time_points)
%     z=['time = ',num2str(time_points(s)/7),'th week'];
    %[z y_var_label(u)]

    %% Compare Si or STi of parameter j with the dummy
    for i=1:k-1
        %% Si

        % Apply student t-test to compare sample mean 
        [a,p_Si(i)]=ttest2(rangeSi(:,i),...
            rangeSi(:,k),alpha,'right','unequal');
       
        %% Sti
        % Apply student t-test to compare sample mean 
        [a,p_Sti(i)]=ttest2(rangeSti(:,i),...
            rangeSti(:,k),alpha,'right','unequal');
           end % for i
    
    SAefast_struct.p_Si=p_Si(:);
    SAefast_struct.p_Sti=p_Sti(:);
%end % for t

    
    s=SAefast_struct;
