% May 22: use setappdata and getappdata to share databetween functions
% setappdata and getappdata functions provide a convenient way to
% share data between callbacks or between separate UIs.

function dynamics(f1s,f2s,eta_basal, wave)

% Ex: dynamics(1,1,0.02,1)

% assign parameter values
setappdata(0,'etabasal_var',eta_basal) % load eta_basal value
                          % in parameter file eta= getappdata(0,'eta_var')

setappdata(0,'fms_var',f1s) % load fms value
                          % in parameter file fms= getappdata(0,'fms_var')


setappdata(0,'fmas_var',f2s) % load fmas value
                          % in parameter file fmas= getappdata(0,'fmas_var')


%--------- Update clearance rates in Parameter file

%f1s = %fM
%f2s = %fMa

ParametersLHS; %update parameter file then feed into ODE



%Initial Values for DCs and tDCs
D0 = 0;
tD0 = 0;


%Initial values
EndTime = 1000;
Tspan = [0 EndTime]; % time in days

% start at the healthy rest state, using Topp
% healthy rest state for beta cells, glucose, insulin

IC = [4.77*10^5 0 0 0 300 100 10 D0 tD0 0 0 0];


%---------------Solve ODE
[T, Y] = ode15s(@(t,y)T1D_ODE(t,y,f1t,f2t,wave),Tspan,IC); % Solve ODE



%Plot the BIG results with and without the wave

%%%%%%%%%%%%%%%Below we replot using weeks%%%%%%%%%%%%%%%
%Convert days into weeks
 EndTime=EndTime./7;
 T=T./7;

 if wave == 0
     str = 'No apoptotic wave';
 else
     str = ['Wave = ', num2str(wave)];
 end


 %Plot the BIG results with and without the wave using weeks
semilogy(T, Y(:,5),'-' , 'LineWidth', 2.5, 'color', [ 0,.4,.8]); hold on;
semilogy(T, Y(:,6),':' , 'LineWidth', 3  , 'color', [ 0,.8,.2]);
semilogy(T, Y(:,7),'-.', 'LineWidth', 3  , 'color', [ 0,.8,.6]);
semilogy(T, ones(size(T)) * 250, 'LineWidth', 1, 'color', 'k');
titlef = '\beta-cell, Glucose, and Insulin';
titlef = [titlef sprintf('\n') str];
title(titlef);
xlabel('Time, weeks');
yalabel = 'Species population';
yalabel = [yalabel sprintf('\n') '(Log scale)'];
ylabel(yalabel);
legend('B','G','I','Location','southeast')
axis([0,EndTime,1,10^3])
set(gca, 'FontSize',25)

end
