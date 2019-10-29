% N. Tania (May 30, 2018) 
% Generate Figure 4
% Box plots of Low v.s. High M steady-state values 

clear close all

%[pars,Init] = load_global;
global ODE_TOL DIFF_INC

ODE_TOL  = 1e-10;
DIFF_INC = sqrt(ODE_TOL);

parset = dlmread('psets_fullrange');

% number of samples to be generated
NMAX = size(parset,1);      % max number of samples
% number of parameters
Npar = 30;
Nvar = 4;

% time points
xdata = (0:10:6000)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% LOOP THROUGH PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SSstore = zeros(NMAX,Nvar);   

kill_NK = zeros(NMAX,1);
kill_Tc = zeros(NMAX,1);
kill_NK_Tc= zeros(NMAX,1);
kill_blockM= zeros(NMAX,1);
kill_blockR= zeros(NMAX,1);
kill_rate = zeros(NMAX,1);

flagg = 0;
parfor i = 1:NMAX

    % parset include sm but we've removed sm from sensitivity   
    Init = parset(i,32:end);    
    pars = parset(i,1:31)';
    pars = pars(2:end);

    
try
    [t,sol] = ode15s(@(t,y)modelBasic(t,y,pars),xdata,Init);
catch 
    disp(lasterr)
    flagg=1;
    sol=[-5 -5 -5 -5];
end

    SSstore(i,:) = sol(end,:);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load parameters
sM = 0.001;	rM = pars(1);	KM = pars(2);	deltaM = pars(3);
aNM = pars(4);	bNM = pars(5);	aCM = pars(6);	bCM = pars(7);
aCNM = pars(8);	aMM = pars(9);	bMM = pars(10);	aRM = pars(11);
bRM = pars(12);	rC = pars(13);	KC = pars(14);	deltaC = pars(15);
aMC = pars(16);	bMC = pars(17);	aNC = pars(18);	bNC = pars(19);
sN = pars(20);	rN = pars(21);	KN = pars(22);	deltaN = pars(23);
aCN = pars(24);	bCN = pars(25);	rR = pars(26);	KR = pars(27);
deltaR = pars(28);	aMR = pars(29);	bMR = pars(30);	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kill_NK(i) = (aNM * sol(end,3)/(bNM + sol(end,3)));
kill_Tc(i) = (aCM * sol(end,2)/(bCM + sol(end,2)));
kill_NK_Tc(i) = (aCNM * sol(end,3)/(bNM + sol(end,3))) * (sol(end,2)/(bCM + sol(end,2)));

kill_blockM(i) = aMM * sol(end,1)/(bMM + sol(end,1));
kill_blockR(i) = aRM * sol(end,4)/(bRM + sol(end,4));

kill_rate(i) = deltaM;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Mss = SSstore(:,1);
Tcss = SSstore(:,2);
Nss = SSstore(:,3);
Trss =SSstore(:,4);

% remove solutions with numerical error
% ifilter = find(Mss>0 & Tcss>0 & Nss>0 & Trss>0);
ifilter = find(Mss>0);
length(ifilter)/NMAX

Mss = SSstore(ifilter,1);
Tcss = SSstore(ifilter,2);
Nss = SSstore(ifilter,3);
Trss =SSstore(ifilter,4);

kill_NK = kill_NK(ifilter);
kill_Tc = kill_Tc(ifilter);
kill_NK_Tc =kill_NK_Tc(ifilter);

kill_blockM = kill_blockM(ifilter);
kill_blockR = kill_blockR(ifilter);

kill_rate = kill_rate(ifilter);

Nsample = length(SSstore)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % Boxplots Low vs High M
idxL = find(Mss<=3);
idxH = find(Mss>3);
% % % 
% % % %%%%%
group = [    ones(size(idxL));
         2 * ones(size(idxH))];
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % Boxplots Low vs High M
idxL = find(Mss<=3);
idxH = find(Mss>3);
% % % 
% % % %%%%%
group = [    ones(size(idxL));
         2 * ones(size(idxH))];
     
% cpurple = [127 0 255]/255;
cpurple = [102 0 102]/255;
corange = [255 128 0]/255;

%% figure 4a
figure 
subplot(2,2,1)
H=boxplot([Mss(idxL);Mss(idxH)],group, 'Labels',{'Low M', ' High M'});
ylabel('M (g/dL)')
set(gca,'fontsize',36)
set(H,{'linew'},{2})
 
% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)
% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(Mss(idxL),Mss(idxH))


subplot(2,2,2)
H=boxplot([Tcss(idxL); Tcss(idxH)],group, 'Labels',{'Low M', ' High M'});
ylabel('T_C (cells/\muL)')
set(gca,'fontsize',36)
set(H,{'linew'},{2})

% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)
% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(Tcss(idxL),Tcss(idxH))


subplot(2,2,3)
H=boxplot([Nss(idxL); Nss(idxH)],group, 'Labels',{'Low M', ' High M'});
ylabel('N (cells/\muL)')
set(gca,'fontsize',36)
set(H,{'linew'},{2})

% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)
% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(Nss(idxL),Nss(idxH))


subplot(2,2,4)
H=boxplot([Trss(idxL); Trss(idxH)], group, 'Labels',{'Low M', ' High M'});
ylabel('T_R (cells/\muL)')
set(gca,'fontsize',36)
set(H,{'linew'},{2})

% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)
% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(Trss(idxL),Trss(idxH))

%% figure 4b
figure 
subplot(2,3,1)
H=boxplot([kill_NK(idxL);kill_NK(idxH)],group, 'Labels',{'Low M', ' High M'});
ylabel('NK Killing ')
set(gca,'fontsize',30)
set(H,{'linew'},{2})
xx=axis;
axis([xx(1:2) -0.5 20])

% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)
% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(kill_NK(idxL),kill_NK(idxH))


subplot(2,3,2)
H=boxplot([kill_Tc(idxL); kill_Tc(idxH)],group, 'Labels',{'Low M', ' High M'});
set(H(1:6,:),'linewidth',2)
ylabel('CTL Killing')
set(gca,'fontsize',30)
set(H,{'linew'},{2})
xx=axis;
axis([xx(1:2) -0.5 20])

% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)
% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(kill_Tc(idxL),kill_Tc(idxH))


subplot(2,3,3)
H=boxplot([kill_NK_Tc(idxL); kill_NK_Tc(idxH)],group, 'Labels',{'Low M', ' High M'});
ylabel({'NK and CTL','Killing'})
set(gca,'fontsize',30)
set(H,{'linew'},{2})
xx=axis;
axis([xx(1:2) -0.5 20])

% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)
% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(kill_NK_Tc(idxL),kill_NK_Tc(idxH))


subplot(2,3,4)
H=boxplot([kill_rate(idxL); kill_rate(idxH)], group, 'Labels',{'Low M', ' High M'});
ylabel('Natural Loss (1/day)')
set(gca,'fontsize',30)
set(H,{'linew'},{2})

% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)
% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(kill_rate(idxL),kill_rate(idxH))

subplot(2,3,5)
H=boxplot([kill_blockM(idxL); kill_blockM(idxH)], group, 'Labels',{'Low M', ' High M'});
ylabel('M Reduction')
set(gca,'fontsize',30)
set(H,{'linew'},{2})
xx=axis;
axis([xx(1:2) -0.05 1])

% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(kill_blockM(idxL),kill_blockM(idxH))


subplot(2,3,6)
H=boxplot([kill_blockR(idxL); kill_blockR(idxH)], group, 'Labels',{'Low M', ' High M'});
ylabel('Treg Reduction')
set(gca,'fontsize',30)
set(H,{'linew'},{2})
xx=axis;
axis([xx(1:2) -0.05 1])

% box
set(H(1:4,:),'color',cpurple,'linewidth',2)
set(H(5,:),'color',cpurple,'linewidth',4)
% median
set(H(6,:),'color',corange,'linewidth',4)
% outliers
set(H(7,:),'MarkerEdgeColor',corange)

% ranksum test
p = ranksum(kill_blockR(idxL),kill_blockR(idxH))




