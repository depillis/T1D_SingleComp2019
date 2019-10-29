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
NR = 30; %: no. of search curves - RESAMPLING
NS = 65; % # of samples per search curve
wantedN=NS*K*NR; % wanted no. of sample points


% OUTPUT
% SI[] : first order sensitivity indices
% STI[] : total effect sensitivity indices
% Other used variables/constants:
% OM[] : vector of k frequencies
% OMi : frequency for the group of interest
% OMCI[] : set of freq. used for the compl. group
% X[] : parameter combination rank matrix
% AC[],BC[]: fourier coefficients
% FI[] : random phase shift
% V : total output variance (for each curve)
% VI : partial var. of par. i (for each curve)
% VCI : part. var. of the compl. set of par...
% AV : total variance in the time domain
% AVI : partial variance of par. i
% AVCI : part. var. of the compl. set of par.
% Y[] : model output

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

%% Pre-allocation of the output matrix Y
%% Y will save only the points of interest specified in
%% the vector time_points

time_points=[70 273]; % time points of interest in days

%Y(NS,length(time_points),length(y0),length(pmin),NR)=0;  % pre-allocation


 % pre-allocation glucose signal
 % Y = [65 2 1 46 30]
Y(NS,length(time_points),1,length(pmin),NR)=0; 



% Loop over k parameters (input factors)
tic
for i=1: K % i=# of replications (or blocks)
    % Algorithm for selecting the set of frequencies.
    % OMci(i), i=1:k-1, contains the set of frequencies
    % to be used by the complementary group.
    
    OMci = SETFREQ(K,OMi/2/MI,i);   
    % Loop over the NR search curves.
    tic
    for L=1:NR
        % Setting the vector of frequencies OM
        % for the k parameters
        cj = 1;
        for j=1:K % pre made a frequency matrix 
            if(j==i)
                % For the parameter (factor) of interest
                OM(i) = OMi; % = 8 
            else
                % For the complementary group.
                OM(j) = OMci(cj); %= 1
                cj = cj+1;
            end
        end
        % Setting the relation between the scalar
        % variable S and the coordinates
        % {X(1),X(2),...X(k)} of each sample point.
        FI = rand(1,K)*2*pi; % random phase shift
        S_VEC = pi*(2*(1:NS)-NS-1)/NS;
        OM_VEC = OM(1:K);
        FI_MAT = FI(ones(NS,1),1:K)';
        ANGLE = OM_VEC'*S_VEC+FI_MAT;
        
        X(:,:,i,L) = 0.5+asin(sin(ANGLE'))/pi; % between 0 and 1
        
        % Transform distributions from standard
        % uniform to general.
        
        %%this is what assigns 'our' values rather than 0:1 dist
        X(:,:,i,L) = parameterdist(X(:,:,i,L),pmax,pmin,0,1,NS,'unif'); 
        
        % save par matrix 
        %csvwrite(['pars',num2str(L),'.csv'], X(:,:,i,L));
        
        
        % assign mat to be parameter  matrix used in parfor loop
        % clear mat after each resampling L loop
        mat = X(:,:,i,L); 
        
        % Do the NS model evaluations.
        parfor run_num=1:NS % NS = sample points for each search curve
        %for run_num=1:NS 
          [i run_num L]
           dlmwrite('current.csv', mat(run_num,:),'delimiter',',','-append');
            size(mat(run_num,:))
            % Assign parameter values 
             %par = assignParameters(X,run_num); 
 
            % dummy=X(run_num,end); %dummy variable 
            % ParameterseFAST; % Load parasmeter values into Paramters file
               
            %% TIME SPAN OF THE SIMULATION
                EndTime=300; % length of the simulations
                tspan=(0:EndTime);   % time points where the output is calculated
            % INITIAL CONDITION FOR THE ODE MODEL
                M0 = mat(run_num,43); % 4.77*10^5;
                Ma0 = 0;
                Ba0 =0 ;
                Bn0 =0 ;
                B0 =300;
                G_0= 100;
                I0 =10;
                D0 =mat(run_num,44); %0;
                tD0=mat(run_num,45); %0;
                E0 =0;
                R_0 =0;
                Em0=0;

                y0=[M0, Ma0, Ba0, Bn0, B0, G_0, I0, D0 , tD0, E0, R_0, Em0];
                
                % ODE solver call
                % temporarily suppress any warning errors
                % if 
                
                w = warning('off');
                
                
                % Sept 9: added myevent(t,y,tstart) to quit integration 
                % if it takes too long 
                
                tstart = tic;
                [t,y]=ode15s(@(t,y)ODE_efast(t,y,wave,mat,run_num),tspan,y0,...
                    odeset('RelTol',1e-10,'AbsTol',1e-10,'Events',@(t,y) myevent(t,y,tstart)));
                
                
   
                glucose = y(:,6);
                rowsize = size(tspan',1);
                
                if size(glucose,1) < rowsize
                    glucose = zeros(rowsize,1); % I dont know what to assign glucose here?
                    % Sept 10: put NA into glucose when this happens. 
                    %save the line of parameter combination that produce numerical error 
                    % the first entry is the row index of glucose matrix
                    dlmwrite('warnings.csv', mat(run_num,:),'delimiter',',','-append');
                end 
                
                
                
                
              %plot(t,glucose); hold on; 
            % It saves only  at the time points of interest
           Y(run_num,:,:,i,L)=glucose(time_points+1,:);
        
        end %run_num=1:NS
    
        clear mat;
    
    end % L=1:NR


end % i=1:k
toc

%in case I dont understand how Y' structure works, save final structure
save Model_efast_T1D ;


% Calculate Coeff. of Var. for Si and STi for Viral load (variable 4). See
% online Supplement A.5 for details.
%[CVsi CVsti]=CVmethod(Si, rangeSi,Sti,rangeSti,4)
