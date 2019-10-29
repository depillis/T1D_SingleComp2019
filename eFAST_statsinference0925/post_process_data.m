function [sorttab, n_tab] = post_process_data(structure,type,alpha)
    Parameter_settings_EFAST_T1D;

    %input= s_T1D structure from efast_sd
    s_T1D = structure;
    id = (1:size(pmax))';
    
    
    % there are 2 type of sensitivity indices
    % we will choose to rank base on SI. 
    % I dont know why?
    
    Sens  = eval(['s_T1D.',type])';
    %pvalues = [s_T1D.p_Si(:,:,s) NaN]';
    pvalues =eval(['[s_T1D.p_',type,'(:); NaN]']);
    
    tbl = table(id, Parameter_var',Sens,pvalues);

    %----------- Plot sorted Si---------

    %only extract variables with p-values < 0.05
    sorttab = tbl(tbl.pvalues<alpha,:);
    %list of all the elements in the subset of significant parameters
    sorttab = sortrows(sorttab,'Sens','descend');
    n_tab = size(sorttab.Sens,1);

%     figure;
%         bar(sorttab.SI,'blue');
%         xticks(1:1:n_tab);
%         set(gca,'xticklabel',sorttab.id, 'FontSize',15);
%         legend(['Week ',num2str(time_points(s)/7)])
%         title({['First order sensitivity index week ',num2str(time_points(s)/7)],...
%             ' p-value <0.05'})
%         
        
%      STi  = s_T1D.Sti(:,s);
%     pvalues = [s_T1D.p_Sti(:,:,s) NaN]';
%     tbl = table(id, Parameter_var',STi,pvalues);

    %----------- Plot sorted Sti---------

%     %only extract variables with p-values < 0.05
%     sorttab = tbl(tbl.pvalues<0.05,:);
%     sorttab = sortrows(sorttab,'STi','descend');
%     n_tab = size(sorttab.STi,1);
% 
%     figure;
%         bar(sorttab.STi,'red');
%         xticks(1:1:n_tab);
%         set(gca,'xticklabel',sorttab.id, 'FontSize',15);
%         legend(['Week ',num2str(time_points(s)/7)])
%         title({['Total order sensitivity index week ',num2str(time_points(s)/7)],...
%             ' p-value <0.05'})

end