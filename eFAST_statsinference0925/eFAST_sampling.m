function mat = eFAST_sampling(K,NS,pmax, pmin,OM)

%input: K: number of parameters 
%       NS: number of sampling points
%       pmax: maximum value of parameters vector
%       pmin: maximum value of parameters vector
%       OM: frequency vector

%output: eFAST sampling matrix

        % Setting the relation between the scalar
        % variable S and the coordinates
        % {X(1),X(2),...X(k)} of each sample point.
        FI = rand(1,K)*2*pi; % random phase shift
        S_VEC = pi*(2*(1:NS)-NS-1)/NS;
        OM_VEC = OM(1:K);
        FI_MAT = FI(ones(NS,1),1:K)';
        ANGLE = OM_VEC'*S_VEC+FI_MAT;
        
        X = 0.5+asin(sin(ANGLE'))/pi; % between 0 and 1
        
        % Transform distributions from standard
        % uniform to general.
        
        %%this is what assigns 'our' values rather than 0:1 dist
        mat = parameterdist(X,pmax,pmin,0,1,NS,'unif'); 
      
        
end

