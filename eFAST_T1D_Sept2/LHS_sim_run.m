%Create a histogram of glucose level by using LHS matrix 

%% Read LHS matrix
mat = csvread('LHS.csv'); 
n = size(mat,1);

%% efast Parameters setting
Parameter_settings_EFAST_T1D;


%% Wave 
wave = 1; 

%% Pre-allocation of the output matrix Y
%% Y will save only the points of interest specified in
%% the vector time_points

time_points=[70 273]; % time points of interest in days




% Do the NS model evaluations.
tic
        parfor run_num=1:n % run_num: number of LHS row 
          
            run_num
            size(mat(run_num,:))
           
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
                    
                options = odeset('RelTol',1e-10,'AbsTol',1e-10);
                [t,y]=ode15s(@(t,y)ODE_efast(t,y,wave,mat,run_num),tspan,y0,options); 
                
                glucose = y(:,6);
                rowsize = size(tspan',1);
                
                if size(glucose,1) < rowsize
                    glucose = zeros(rowsize,1); % I dont know what to assign glucose here?
                    
                    %save the line of parameter combination that produce numerical error 
                    % the first entry is the row index of glucose matrix
                    dlmwrite('LHS_warnings.csv', mat(run_num,:),'delimiter',',','-append');
                end
                
                
              %plot(t,glucose); hold on; 
            % It saves only  at the time points of interest
           
      dlmwrite('LHS_out_mat.csv', glucose(time_points+1,:),'delimiter',',','-append');

        
        end %run_num
toc

