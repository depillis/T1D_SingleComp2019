function formLHS(sizemat, fmin, fmax)


%prepare grid of parameters values fM, fMa
n = sizemat;
% fmin = 0.1; 
% fmax = 2; 

%-----------------------------------

fM = sort(LHS_Uniform(fmin,fmax,n)); 
fMa = sort(LHS_Uniform(fmin,fmax,n));
[f1, f2] = meshgrid(fM,fMa);
% 

%-------- putting them into vector
f1 = reshape(f1, [], 1); 
f2 = reshape(f2, [],1);
LHS = [f1 f2];

%----- Save as LHS.csv

csvwrite('LHStest.csv',LHS);

end 