function parambarplot(percent, wave,timepoint,filename,savefileID)

%input: filename = 'LHS1.csv'
%       percent = varying percentage of parameter value E.g. 5% 
%       wave = wave strength varying between 0 and 1 
%       timepoint= of recording glucose level in days 
%       savefileID = 1,2,3.... since we manually parallelize code

Parameter_settings_LHS;


LHS =  csvread(filename); % call LHS and extract a row from the matrix 
n = size(LHS,1); 
output = zeros(size(LHS));
s = length(Parameter_var);


 
parfor j = 1:n % rows LHS 
    par = LHS(j,:); 
    plotsol = zeros(s,2);

   for i = 1:s %parameters 

        [j i] 
        
        % take each line of LHS
        sol = zeros(3,1); 
        
        splt_par = repmat(par,3); %duplicate the vector of parameters
        splt_par(1,i) =  splt_par(1,i)*(1- percent/100); % down by some percent 
        splt_par(3,i) =  splt_par(1,i)*(1+ percent/100); % up by some percent
        
        
        % for each line of parameter feed it into ode to solve 
        sol(1) = odesolve(splt_par(1,:),wave,timepoint) %solve ODE
        sol(2) = odesolve(splt_par(2,:),wave,timepoint) %solve ODE
        sol(3) = odesolve(splt_par(3,:),wave,timepoint) %solve ODE

        plotsol(i,:) = ((sol([1,3])/sol(2))-1)*100; %percent change in glucose 
         
    end % parameters
    
    
   percentchange = abs(plotsol); %matrix with first column
                                 % is decrease and 2nd is increase
   output(j,:) = max(percentchange,[],2); %maximum absolute change per parameter
end % end looping rows of LHS matrix 

%save output matrix 
csvwrite(['localsensitivity',num2str(savefileID),'.csv'], output); 


end 
