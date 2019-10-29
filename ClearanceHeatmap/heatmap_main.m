function  heatmap_main(eta_basal, wave)

% generate glucose heatmap as a combination of macrophages fM and fMa 
% LHS matrix already generated in this folder 

% Inputs are optional 
% If no input are entered, heatmap for existing data will be generated 
% For any input of eta_basal and wave, function will generate glucose data 
% then generate heatmap for the new eta_basal and wave 



if nargin < 1 %default setting, we will plot the heat map for the existing data 
     eta_basal = linspace(0.0075,0.03,5);

    figure; 
    heatmap(eta_basal(3),'./data/LHS.csv', 0);
%     hold on;
%     contourmap('glucose',eta_basal(1), './data/LHS.csv', 0,'-','red' );
    hold on;
    contourmap('glucose',eta_basal(3), './data/LHS.csv',1 ,'-','red' );
    xlim([0.6 1.4])
    legend(['No wave, \eta_{basal} = ', num2str(eta_basal(3))],...
        ['Wave = 1, \eta_{basal} = ', num2str(eta_basal(3))]);

    title('NOD region')
    
else %generate modified heatmap for different value of eta_basal and wave
    %E.g: heatmap_main(0.01, 0.75)
    
    % prepare x and y-axis of the heat map 
    LHS = csvread('./data/LHS.csv'); % use the existing LHS matrix 
    nmat = sqrt(size(LHS,1));
    fM = reshape(LHS(:,1),nmat,nmat); 
    fMa = reshape(LHS(:,2),nmat,nmat); 
    
    % Simulate data using T1D_sim 
    % output files will be saved in this folder
    T1D_sim('./data/LHS.csv', eta_basal, wave);  
    
    % access output file 
    file = csvwrite(['eta',num2str(eta_basal),'wave_',num2str(wave),'.csv']);
    glucose = reshape(file(:,2), nmat, nmat);
    time_sick = reshape(file(:,1), nmat, nmat);
    
    %plotting 
    wavetitle = ['Wave = ', num2str(wave)] ; 
    
    clims = [100 300 ];
    imagesc(LHS(:,1),LHS(:,2),glucose, clims); 
    
    hold on; 
    
    %---------------- contour glucose
    
    glu_levels = [1, 250]; 
    gluheat = contour(fM, fMa,glucose, glu_levels,...
        'LineWidth',3,'EdgeColor', 'cyan');
    clabel(gluheat,'Color','cyan','FontSize',15)
    
   
    hold on;
    
    %------------- contour timesick
    time_levels = [1, 142.8]; % levels of Time_Sick 
    timeheat = contour(fM, fMa,time_sick,time_levels,...
        'LineWidth',3, 'EdgeColor','magenta');
    clabel(timeheat,'Color','magenta','FontSize',15)
    %   c = colorbar;
    %   c.Label.String = 'Glucose level';
    xlabel('fM'); 
    ylabel('fMa');
    str = [{'\eta_{basal} = ',num2str(eta_basal)}, {wavetitle}];
    title(str);
    set(gca,'YDir','normal', 'FontSize', 20);

    
end 
    




end

