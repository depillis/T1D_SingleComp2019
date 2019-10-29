function Y = model_solver(mat,run_num, wave,time_points)

%input: mat: sampling matrix 
%       run_num: row of matrix that being simulated
%       wave: wave strength 
%       time_points: time of interest
%output: Y: glucose matrix 
%        1st column: 10th week 
%        2nd column: 40th week 

%% TIME SPAN OF THE SIMULATION
                EndTime=300; % length of the simulations
                tspan=(0:EndTime);   % time points where the output is calculated
            
             % INITIAL CONDITION FOR THE ODE MODEL
                M0 =  4.77*10^5;
                Ma0 = 0;
                Ba0 =0 ;
                Bn0 =0 ;
                B0 =300;
                G_0= 100;
                I0 =10;
                D0 = 0;
                tD0= 0;
                E0 =0;
                R_0 =0;
                Em0=0;

                y0=[M0, Ma0, Ba0, Bn0, B0, G_0, I0, D0 , tD0, E0, R_0, Em0];
                
             % Solver will quit if taking more than 100 seconds  
               tstart = tic;
                [t,y]=ode15s(@(t,y)ODE_efast(t,y,wave,mat,run_num),tspan,y0,...
                    odeset('RelTol',1e-10,'AbsTol',1e-10,'Events',...
                    @(t,y) myevent(t,y,tstart)));
                
             % only save glucose level 
                glucose = y(:,6);
             
             % flag numerical instability
             % glucose vector will be assigned with NAN
                rowsize = size(tspan',1);
                if size(glucose,1) < rowsize
                    glucose = nan(size(tspan',1));
             % save the parameter combination that yields numerical
             % instability 
                    dlmwrite('warnings.csv', mat(run_num,:),'delimiter',',','-append');
                end 
    
            Y=glucose(time_points+1,:);  
end

