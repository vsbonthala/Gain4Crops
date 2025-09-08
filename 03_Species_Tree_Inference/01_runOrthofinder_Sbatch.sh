#!/bin/bash

#SBATCH --mail-type all
#SBATCH --job-name=OrthoFinder
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH -N 1
#SBATCH -n 50
#SBATCH --mem 100G
#SBATCH -p largemem
#SBATCH -t 07-00:00:00


# Tool paths
OrthoFinder=~/myTools/OrthoFinder/orthofinder

echo "Running OrthoFinder..."
echo " "
date
echo " "

$OrthoFinder -t 50 -n AllSpeciesNew2 -z -y -f .

date
echo " "
echo "OrthoFinder completed..."
### END ###
