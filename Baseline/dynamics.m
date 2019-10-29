% May 22: use setappdata and getappdata to share databetween functions
% setappdata and getappdata functions provide a convenient way to
% share data between callbacks or between separate UIs.

function dynamics(f1s,f2s,eta_basal, wave)

% Ex: dynamics(1,1,0.02,1)

setappdata(0,'fms_var',f1s) % load fms value
                          % in parameter file fms= getappdata(0,'fms_var')

setappdata(0,'fmas_var',f2s) % load fmas value
                          % in parameter file fmas= getappdata(0,'fmas_var')

setappdata(0,'etabasal_var',eta_basal) % load fmas value
                          % in parameter file fmas= getappdata(0,'fmas_var')


%--------- Update clearance rates in Parameter file

ParametersLHS; %update parameter file then feed into ODE


%---------------Solve ODE
[T, Y] = ode15s(@(t,y)T1D_ODE(t,y,f1t,f2t,wave),tspan,y0); % Solve ODE



%Plot the BIG results with and without the wave

%-----------Below we replot using weeks-%
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
