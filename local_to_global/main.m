%% July 29, An's code 
tic
parpool; 
%% Run analysis 
 parambarplot(5,1,280, 'LHS1.csv',1); % change parameter value by 5% with wave
%parambarplot(5,1,'LHS2.csv',2);
toc

LHS1 = csvread('LHS1.csv'); 
LHS2 = csvread('LHS2.csv'); 
LHS = [LHS1; LHS2];

out1 = csvread('localsensitivity1.csv'); 
out2 = csvread('localsensitivity2.csv');
out = [out1; out2];
% % Plotting local to global sensitivity 
% 
Parameter_settings_LHS; % load parameter names and values 

% For plotting purpose, create id vectors 
% These ID will appear in the x-axis as parameter names 
% look-up table is parameter_table.csv 

n = size(Parameter_var,2); 
ID = (1:1:n)';



%------- Statistical Test ------------%

k = size(out,2); % number of parameters+ dummy 
p = zeros(k-1,1); 
alpha=0.05; 

for i=1:k-1
  [a,p(i)]=ttest2(out(:,i),out(:,k),alpha,'right','unequal');
end % for i
 
avg= mean(out(:,1:k-1))';
tab = table(ID(1:k-1),Parameter_var(1:k-1)',avg,p);
T = tab(tab.p<0.05,:);
T = sortrows(T,-3);

figure; 
bar(T.avg)
hold on; 
plot([0,size(T,1)],[1,1],'LineWidth',3)
xticks(1:1:size(T,1)); 
ylabel('\Delta end-glucose level ')
title('Local to Global Sensitivity')
set(gca,'xticklabel', T.Var1, 'fontsize',20)
