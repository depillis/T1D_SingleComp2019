% N. Tania (May 30, 2018) 
% Generate Fig 2A
% Simulate ODE using Base Column Values in Table 2

sM = 0.001;
rM = 0.0175;
KM = 10;
deltaM = 0.002;

rC = 0.013;
KC = 800;
deltaC = 0.02;

sN = 0.03;
rN = 0.04;
KN = 450;
deltaN = 0.025;

rR = 0.0831;
KR = 80;
deltaR = 0.0757;

%%%%%%%%%%%%%%%%%%%%%%%

aNM=5;
bNM=150;
aCM=5;
bCM=375;
aCNM=8;
aMM = 0.5;
bMM = 3;
aRM = 0.5;
bRM = 25;

aMC = 5;
bMC = 3;
aNC = 1;
bNC = 150;

aCN = 1;
bCN = 375;

aMR = 2;
bMR = 3;

M0 = 4;
TC0 = 464;
N0 = 227;
TR0 = 42;

par = [rM KM deltaM aNM bNM aCM bCM aCNM aMM bMM aRM bRM ...
    rC KC deltaC aMC bMC aNC bNC ...
    sN rN KN deltaN aCN bCN ...
    rR KR deltaR aMR bMR];

IC = [M0 TC0 N0 TR0];

[t,sol] = ode15s(@(t,y)modelBasic(t,y,par),[0:10:1500],IC);

M = sol(:,1);
TC = sol(:,2);
N = sol(:,3);
TR = sol(:,4);

fig = figure
set(fig,'defaultAxesColorOrder',[0 0 0; 0 0 0]);

yyaxis left
plot(t,M,'-','Color',[1 0 0],'linewidth',4)
ylabel('M protein (g/dL)'), xlabel('t (days)'),
set(gca,'fontsize',50)


yyaxis right
plot(t,TC,'-.','Color',[0 0 1], 'linewidth',4), hold on
plot(t,N,'--','Color',[0.301960796117783 0.745098054409027 0.933333337306976], 'linewidth',4)
plot(t, TR,':','Color',[0 0.498039215803146 0], 'linewidth',4)
ylabel('Immune Cells (cells/\muL)')
set(gca,'fontsize',50)


legend({'M  ', 'T_C  ','N  ','T_R  '},'Orientation','horizontal')