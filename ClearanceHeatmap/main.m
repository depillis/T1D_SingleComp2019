% Generate LHS matrix then save as LHS.csv 
% since it is already exist, turn it off 
% 
n = 50;  % size of fms and fmas vector 
fmin = 0.1;    % minimum value
fmax = 2;    % maximum value

%form LHS matrix 
formLHS(n, fmin, fmax);

% here are all the values of eta_basal that we want to study

eta_basal = linspace(0.0075,0.03,5);
size_etabasal = size(eta_basal,2);


%looping through eta_basal to run simulation.
% should see 15 csv files in the current directory

for i = 1: size_etabasal
   T1D_sim('LHS.csv',eta_basal(i))
end

figure; 
heatmap(eta_basal, 'LHS.csv', 0)

figure; 
heatmaptimesurf(0.03,'LHS.csv',1)