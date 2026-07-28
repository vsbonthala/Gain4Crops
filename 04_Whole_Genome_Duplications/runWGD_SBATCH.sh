#!/bin/bash
#SBATCH --job-name=WGD
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH -p normal
#SBATCH -t 21-00:00:00
#SBATCH -N 1
#SBATCH -n 50
#SBATCH --mem 50G

# Activate MAKER's conda environment
eval "$(conda shell.bash hook)"

conda activate ~/myTools/conda/mini3/envs/WGD


cds=$1

echo "Computing Panrome..."
~/myTools/wgdV2/wgd/ENV/bin/wgd dmd --cds $cds -n 50 &> wgd_dmd.log

echo "Computing Ks..."
~/myTools/wgdV2/wgd/ENV/bin/wgd ksd --cds --pairwise -n 50 wgd_dmd/"$cds".tsv $cds &> wgd_ksd.log

echo "Pipeline complete..."
### END ###