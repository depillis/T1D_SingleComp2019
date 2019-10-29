function contourmap(maplab, etavalues, LHSfile, wavestrength,linestyle, linecolor)

% Ex: 


%input
%etavalues = fixed 1 value 
% LHSmat = 'LHS.csv'
% wave strength= fixed value 

%output: compare the heatmap and area between 2 contours
% as function of wave 

%load vector of eta_basal using in the simulation main file. 
eta_basal = etavalues; 
% n = size(wavestrength,2); 

LHS = csvread(LHSfile);
nmat = sqrt(size(LHS,1));
fM = reshape(LHS(:,1),nmat,nmat); 
fMa = reshape(LHS(:,2),nmat,nmat); 

% load corresponding csvfiles for each purpose 

% graph heatmap + glucose contour + time contour 


if wavestrength == 0
        file = csvread(['./data/eta',num2str(eta_basal),'_nowave.csv']);
        wavetitle = 'No apoptotic wave';
elseif wavestrength == 0.5
        file = csvread(['./data/eta',num2str(eta_basal),'_wave_05.csv']);
        wavetitle = ['Wave = ', num2str(wavestrength)] ; 
else 
        file = csvread(['./data/eta',num2str(eta_basal),'_wave_1.csv']);
        wavetitle = ['Wave = ', num2str(wavestrength)] ;
end

    
    glucose = reshape(file(:,2), nmat, nmat);
    time_sick = reshape(file(:,1), nmat, nmat);
    
    
    %---------------- heat map glucose 
     
%     clims = [100 300 ];
%     imagesc(LHS(:,1),LHS(:,2),glucose, clims); 
    
    
    %---------------- contour glucose
    
    if strcmp('glucose',maplab) == 1
        glu_levels = [1, 250]; 
        gluheat = contour(fM, fMa,glucose, glu_levels,linestyle,...
        'LineWidth',3,'EdgeColor',linecolor);
        %clabel(gluheat,'FontSize',15)
    else 
         time_levels = [1, 142.8]; % levels of Time_Sick 
        timeheat = contour(fM, fMa,time_sick,time_levels,linestyle,...
        'LineWidth',3, 'EdgeColor',linecolor);
       % clabel(timeheat,'FontSize',15)
    end 
    
    
    xlabel('fM'); 
    ylabel('fMa');
    str = ['\eta_{basal} = ',num2str(eta_basal), sprintf('\n')];
    %title(str);
    %legend(wavetitle);
    set(gca,'YDir','normal', 'FontSize', 20);

    
end





