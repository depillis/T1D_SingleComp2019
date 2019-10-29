# T1D_SingleComp
# Baseline 

Parameter_Table.csv: describe parameter names, baseline values, max and min values 

Parameter_settings.m: set up max/min and baseline values of 42 model parameters, time span, initial conditions, and model variables

ParametersLHS: assign baseline values defined in Parameter_settings.m to model parameters with the exception for 
eta_basal, f1s and f2s will retrieve values from user input 


T1D_ODE: defines the system of ODE 

dynamics.m: display glucose dynamics as function of eta_basal, f1s (resting macrophages clearance rate) and f2s (active macrophages clearance rate) and wave

baseline_dynamics: display glucose dynamics for BalbC mouse and NOD mouse parameters 