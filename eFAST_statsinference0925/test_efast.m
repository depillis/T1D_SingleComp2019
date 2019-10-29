
Parameter_settings_EFAST_T1D;

NR = 30;
wave = 1; 
time_points=280; % time points of interest in days

K = size(pmax,1); % # of input factors (parameters varied) + dummy parameter
NS = 129; % # of samples per search curve
wantedN=NS*K*NR; % wanted no. of sample points
MI = 4; %: maximum number of fourier coefficients
        % that may be retained in calculating the partial
        % variances without interferences between the
        % assigned frequencies
        % generally equals to 4 or 6

% Computation of the frequency for the group
% of interest OMi and the # of sample points NS (here N=NS)

OMi = floor(((wantedN/NR)-1)/(2*MI)/K);%always equal to 8 
NS = 2*MI*OMi+1;

if(NS*NR < 65)
    fprintf(['Error: sample size must be >= ' ...
    '65 per factor.\n']);
    return;
end


%% pre-allocation: glucose signal, Si, Sti, rangeSi, rangeSti
  Si = zeros(length(pmin), length(time_points)); 
  Sti = zeros(length(pmin),length(time_points)); 
  rangeSi = zeros(NR, length(time_points),length(pmin)); 
  rangeSti = zeros(NR, length(time_points),length(pmin)); 
  
%% Compute Sensitivity index
%parpool
tic
for i=1:K % Loop over k parameters (input factors)
%for i=1:K % Loop over k parameters (input factors)
    % i=# of replications (or blocks)
    % Algorithm for selecting the set of frequencies.
    % OMci(i), i=1:k-1, contains the set of frequencies
    % to be used by the complementary group.
    

%% 
    OMci = SETFREQ(K,OMi/2/MI,i); 
    OM = OMci;
    OM(i) = OMi;
    %[OMci(1:i-1) OMi OMci(i:K-1)];
     
    
    %Allocation for variance computation 
     Vi = zeros(NR,length(time_points));
     Vci = zeros(NR,length(time_points));
     V = zeros(NR,length(time_points));
        
    % Loop over the NR search curves.
    for L=1:NR
        
        % Create sampling matrix 
        mat = eFAST_sampling(K,NS,pmax,pmin,OM);
        
        %allocate glucose matrix 
        Y = zeros(NS, length(time_points));
        
        % Simulate dynamics model for glucose level
        parfor run_num=1:NS 
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


save test_efast.mat 