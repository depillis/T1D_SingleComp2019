#!/bin/bash
#SBATCH --job-name="LHS_run"
#SBATCH --output="matlab.%j.%N.out"
#SBATCH --partition=compute
#SBATCH --nodes=10
#SBATCH --export=ALL
#SBATCH --ntasks-per-node=24
#SBATCH -L matlab:1
#SBATCH -t 01:00:00
module load matlab
matlab -nojvm -nodesktop -nodisplay -r "run LHS_sim_run; quit"

