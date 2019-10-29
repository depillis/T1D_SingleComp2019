%% Steady state sample  distribution  
%  Using Kullback Leibler distance to determine if the sample
% distribution is at the steady state 
% %Compute Kullback distance between 2 consecutive distribution
% % We may be able to  use this as a criteria to choose number of
% resampling scheme NR 

dist = zeros(75,K);
for i =1:K % loop over parameter
    for n = 25:99 % loop over NR= 25:49. when NR is too small, not much statistics
                    % to work with
    Si_n = Si(1:n,i);
    Si_N = Si(1:n+1,i);
    hist_Si_n = hist(Si_n); 
    hist_Si_N= hist(Si_N); 
    dist(n-24,i) = KLDiv(hist_Si_n, hist_Si_N);
    end 
end
figure;
plot(dist)

% The plot shows the sample distribution approach steady state at NR = 30

%% Pre-req to sample t-test: normal distribution?
%  the one-sample Kolmogorov-Smirnov test.
% null hypothesis: data comes from a standard normal distribution
% alternative hypothesis: it does not come from such a distribution
%  h is 1 if the test rejects the null hypothesis at the 5% significance level

kolmogorov=zeros(K,1); 

for i = 1:K-1 
    kolmogorov(i) = kstest(Si(:,i));
end 

% The results shows not all the sample parameter distribution share the
% same variance with the dummy parameters 
% Below is the list of parameter that does not share the same variance with dummy
% parameter distribution

id(kolmogorov==1)

%% Pre-requisite to use sample t-test: equal variance?
% Two-sample F-test for equal variances 
% Null hypotheses: they come from normal distributions 
% with the same variances. 
% Alternative hypothesis: they come from normal distributions 
% with different variances. 
% The result h is 1 if the test rejects the null hypothesis 
% at the 5% significance level, and 0 otherwise.

h=zeros(K,1); 

for i = 1:K-1 
    h(i) = vartest2(Si(:,i),Si(:,end));
end 

% The results shows not all the sample parameter distribution share the
% same variance with the dummy parameters 
% Below is the list of parameter that does not share the same variance with dummy
% parameter distribution

id(h==1)

%% Welch's student t-test 
% implemented in matlab as ttest2()

welch= zeros(K-1,1); 
p_welch = welch; 

for i = 1:K-1 
    [welch(i) p_welch(i) ] = ttest2(Sti(:,i),Sti(:,end),0.05/42,...
        'right','unequal');
end 



%% Wilcox rank sum test 
wilcox=zeros(K-1,1); 
p_wilcox = zeros(K-1,1);

for i = 1:K-1 
    [p_wilcox(i) wilcox(i)] = ranksum(Sti(:,i),Sti(:,end),'alpha',0.05/42,...
        'tail','right');
end 


%% Compare 2 tests 
id(welch == 1)
id(wilcox==1)



%% parameter distribution
figure
for i = 20:100 
    hist(Si(1:i,41),15)
        axis([0 0.4 0 30])
    pause(.1)
end 
