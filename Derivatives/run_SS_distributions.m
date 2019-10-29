% N. Tania (May 30, 2018) 
% Generate Figure 2B - steady state histograms 

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

SSstore = zeros(NMAX,Nvar);

% track for numerical failures (ODE integration does not converge)
failSet = []; Nfail = 0;



parfor jj =1:NMAX
  
  % parset include sm but we've removed sm from sensitivity   
Init = parset(jj,32:end);    
pars = parset(jj,1:31)';
pars = pars(2:end);

opts = odeset('RelTol',ODE_TOL, 'AbsTol',ODE_TOL);

[t,sol] = ode15s(@(t,y)modelBasic(t,y,pars),xdata,Init,opts);

SSstore(jj,:) = sol(end,:);
end

Mss = SSstore(:,1);
Tcss = SSstore(:,2);
Nss = SSstore(:,3);
Trss =SSstore(:,4);

figure
subplot(2,2,1)
c=[1 0 0];
histogram(Mss,[0,3,8,15],'LineWidth',2,'FaceColor',c,'FaceAlpha',0.75)
xlabel('M protein (g/dL)')
capt = strcat('mean =',num2str(mean(Mss)))
title(capt)
set(gca,'fontsize',30)
set(gca,'linewidth',2)

subplot(2,2,2)
c=[0 0 1];
histogram(Tcss,20,'LineWidth',2,'FaceColor',c,'FaceAlpha',0.75)
xlabel('CTL (cells/\muL)')
capt = strcat('mean =',num2str(mean(Tcss)))
title(capt)
set(gca,'fontsize',30)
set(gca,'linewidth',2)


subplot(2,2,3)
c=[0.301960796117783 0.745098054409027 0.933333337306976];
histogram(Nss,20,'LineWidth',2,'FaceColor',c,'FaceAlpha',0.75)
xlabel('NK (cells/\muL)')
capt = strcat('mean =',num2str(mean(Nss)))
title(capt)
set(gca,'fontsize',30)
set(gca,'linewidth',2)


subplot(2,2,4)
c=[0 0.498039215803146 0];
histogram(Trss,20,'LineWidth',2,'FaceColor',c,'FaceAlpha',0.75)
xlabel('Treg (cells/\muL)')
capt = strcat('mean =',num2str(mean(Trss)))
title(capt)
set(gca,'fontsize',30)
set(gca,'linewidth',2)

