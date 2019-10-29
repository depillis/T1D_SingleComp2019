function post_process_data(filename)
    
    %input= s_T1D.mat
    %load structure saved from Model_efast_T1D
    load(filename)
    id = (1:size(pmax))';

for s = 1:length(time_points)
    SI  = s_T1D.Si(:,s);
    pvalues = [s_T1D.p_Si(:,:,s) NaN]';
    tbl = table(id, Parameter_var',SI,pvalues);

    %----------- Plot sorted Si---------

    %only extract variables with p-values < 0.05
    sorttab = tbl(tbl.pvalues<0.05,:);
    sorttab = sortrows(sorttab,'SI','descend');
    n_tab = size(sorttab.SI,1);

    figure;
        bar(sorttab.SI,'blue');
        xticks(1:1:n_tab);
        set(gca,'xticklabel',sorttab.id, 'FontSize',15);
        legend(['Week ',num2str(time_points(s)/7)])
        title({['First order sensitivity index week ',num2str(time_points(s)/7)],...
            ' p-value <0.05'})
        
        
     STi  = s_T1D.Sti(:,s);
    pvalues = [s_T1D.p_Sti(:,:,s) NaN]';
    tbl = table(id, Parameter_var',STi,pvalues);

    %----------- Plot sorted Sti---------

    %only extract variables with p-values < 0.05
    sorttab = tbl(tbl.pvalues<0.05,:);
    sorttab = sortrows(sorttab,'STi','descend');
    n_tab = size(sorttab.STi,1);

    figure;
        bar(sorttab.STi,'red');
        xticks(1:1:n_tab);
        set(gca,'xticklabel',sorttab.id, 'FontSize',15);
        legend(['Week ',num2str(time_points(s)/7)])
        title({['Total order sensitivity index week ',num2str(time_points(s)/7)],...
            ' p-value <0.05'})
end 
end