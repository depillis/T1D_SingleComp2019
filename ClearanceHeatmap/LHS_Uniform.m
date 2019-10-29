%Write simple code that uses latin hypercube sampling with uniform
%distribution on parameter ranges

function s=LHS_Uniform(xmin,xmax,nsample,threshold)

%If no threshold is specified ignore it by including a ridiculously large
%number
if nargin<4
    threshold=1e20;
end

%Start the sampling procedure using the min and max values of each
%parameter

if xmin==0
        xmin=1e-300;
    end
    nvar=length(xmin);
    ran=rand(nsample,nvar); %Generate random numbers
    s=zeros(nsample,nvar); %Generate sample
    
    %For a given variable
    for j=1: nvar
        idx=randperm(nsample);%Randomly permute the sample indexes
        P =(idx'-ran(:,j))/nsample;
        xmax(j);
        xmin(j);
        xmax(j)/xmin(j);
        if (xmax(j)<1 & xmin(j)<1) || (xmax(j)>1 & xmin(j)>1)
            'SAME RANGE';
            %% It uses the log scale if the order of magnitude of [xmax-xmin] is bigger than threshold
            if (xmax(j)/xmin(j))<threshold 
                '<1e3: LINEAR SCALE';
                s(:,j) = xmin(j) + P.* (xmax(j)-xmin(j));
            else
                '>=1e3: LOG SCALE';
                s(:,j) = log(xmin(j)) + P.*abs(abs(log(xmax(j)))-abs(log(xmin(j))));
                s(:,j) = exp(s(:,j));
            end
        else
            'e- to e+';
            %% It uses the log scale if the order of magnitude of [xmax-xmin] is bigger than threshold
            if (xmax(j)/xmin(j))<threshold 
                '<1e3: LINEAR SCALE';
                s(:,j) = xmin(j) + P.* (xmax(j)-xmin(j));
            else
                '>=1e3: LOG SCALE';
                s(:,j) = log(xmin(j)) + P.*abs(log(xmax(j))-log(xmin(j)));
                s(:,j) = exp(s(:,j));
            end
        end
    end
    
    
end