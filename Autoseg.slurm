#!/bin/bash

#SBATCH --job-name=Autoseg
#SBATCH --output=%x_%j.out
#SBATCH --mail-user="a.t.jaglal@lumc.nl"
#SBATCH --mail-type="ALL"
#SBATCH --partition=short
#SBATCH --time=00:00:15
#SBATCH --ntasks=1
#SBATCH --mem=10M

#clean environment 
#module purge

echo "## loading module"
module load neuroImaging/fsl/6.0.6
module load system/python/3.11.3
module load neuroImaging/ANTs/2.3.5/gcc-8.3.1
#module load library/cuda/9.2/gcc.8.3.1

# Source the Python virtual environment
source $HOME/Optic_Nerve_Segmentation_3DU-Net/venv/bin/activate

TEST_DIR=$(pwd)
echo "## Current directory $TEST_DIR"