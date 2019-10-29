function baseline_dynamics


figure; 

subplot(2,2,1); 
dynamics(2,5,0.01,0); %generate dynamics as a fuction of    
                        % fms and fmas, eta_basal and wave

subplot(2,2,2); 
dynamics(0.9,1,0.01,0);

subplot(2,2,3); 
dynamics(2,5,0.01,1);

subplot(2,2,4); 
dynamics(0.9,1,0.01,1);

end