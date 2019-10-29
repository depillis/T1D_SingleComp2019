% Algorithm for selection of a frequency
% set for the complementary group. Done
% recursively as described in:
% Appendix of "Sensitivity Analysis"
% [Saltelli et al., 2000]
%OMci = SETFREQ(k-1,OMi/2/MI) 


% sampling procedure in eFAST
% Kci: number of parameters 
% OMciMAX = maximum allowable frequency of complement set 

function OMci = SETFREQ(Kci,OMciMAX)
if Kci==1
    OMci = 1;
elseif OMciMAX==1
    OMci = ones(1,Kci);
else
    if(OMciMAX < Kci)
         INFD = OMciMAX;
    else
        INFD = Kci;
    end
    
    % always equal to 1 but in Salteli mention it could be more than 1
    ISTEP = round((OMciMAX-1)/(INFD-1)); 
    
    
    if(OMciMAX == 1)
        ISTEP = 0;
    end
    OTMP = 1:ISTEP:INFD*ISTEP;
    fl_INFD = floor(INFD);
    for i=1:Kci
        j = mod(i-1,fl_INFD)+1;
        OMci(i) = OTMP(j);
    end
end
%OMci(f)=[];