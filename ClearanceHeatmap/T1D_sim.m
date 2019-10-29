% July 19/2019
% Generate model outcomes (glucose at the end of 600 days) and time sick 
% as a function of clearance rates fm and fma 
% This file will generate heatmap of fm and fma for different values of eta_basal and wave 



function T1D_sim(lhsfilename,eta_basal,wave)

% T1Dsim takes in LHS.csv file and eta_basal
% for example T1Dsim('LHS.csv', 0.01, 0.75)

Parameter_settings;

LHS = csvread(lhsfilename);
n = size(LHS, 1); 




for i = 1 : n

    
%----Update scale of clearance rates f1s and f2s

f1s = LHS(i,1);
f2s = LHS(i,2); 

setappdata(0,'fms_var',f1s) % load fms value 
                          % in parameter file fms= getappdata(0,'fms_var')
                          
setappdata(0,'fmas_var',f2s) % load fmas value 
                          % in parameter file fmas= getappdata(0,'fmas_var')

%------ Read eta_basal value -------- % 
setappdata(0,'etabasal_var',eta_basal); 
                          
                          
%update parameter file (ParametersLHS) then feed into ODE                          

ParametersLHS;
                         
%----- set options to flag when glucose crosses threshold of 250mg                          
options=odeset('Events',@sickEvents);

%--------------- Solve ODE -------------- 
% called out ODE file rename it to clearance_heatmap_ODE

[Tnwave, Ynwave,Te,Ye,ie] =...
    ode15s(@(t,y)T1D_ODE(t,y,f1t,f2t,wave),tspan,y0,options); % Solve ODE

Time_sick=Te./7; % save time when glucose crosses threshold
glucose = Ynwave(:,6);  % save glucose signal 


%------------If the event finder did not return anything
%---------then the glucose has not reached 250 during this simulation

if isempty(Time_sick) == 1
    Time_sick = EndTime./7; 
end

%if Time_sick has only 1 entry then append 1st entry into etabasal.csv file
% and append 0 into hypo.nowave.csv  

if length(Time_sick) > 1 % if there are more than 1 time glucose level crosses 
                            % threshold, it could be hypoglycemic condition 
                            % save the pre-diabetic stage in hypo_eta file 
                            % and record the first day it crosses threshold 
                            % and end glucose level
    
    dlmwrite(['hypo_eta',num2str(eta_basal),'wave_',num2str(wave),'.csv'],...
    abs(Time_sick(2)-Time_sick(1)),'-append');

       
    dlmwrite(['eta',num2str(eta_basal),'wave_',num2str(wave),'.csv'],...
    [Time_sick(1) glucose(end)],'-append');

else % if there is only 1 time glucose level crosses threshold then it is sick condition  
    % save 0 in the hypo file   
    % save the time mice get sick and end-glucose level  
    
    dlmwrite(['hypo_eta',num2str(eta_basal),'wave_',num2str(wave),'.csv'],...
   0,'-append');
    
    %append Time_sick into matrix
    dlmwrite(['eta',num2str(eta_basal),'wave_',num2str(wave),'.csv'],...
    [Time_sick glucose(end)],'-append');

end %length(Time_sick)



end %i 

end % end function 