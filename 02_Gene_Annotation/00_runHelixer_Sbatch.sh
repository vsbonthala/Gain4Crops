#!/bin/bash

#SBATCH --mail-type all
#SBATCH --job-name=Helixer
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -p normal
#SBATCH --mem 100G
#SBATCH -t 24:00:00
##SBATCH --gres=gpu:a100:1
##SBATCH --exclusive

# Activate Helixer's env
source ~/myTools/Helixer/env/bin/activate

# Load Singularity
module reset
module load system singularity


# Run Helixer
echo "Running Helixer..."

# Set species name
IN="C_basalis"

singularity run helixer-docker_helixer_v0.3.0a0_cuda_11.2.0-cudnn8.sif Helixer.py \
                --fasta-path "$IN"_genome.fa \
                --species $IN \
                --gff-output-path "$IN"_genome_Helixer.gff3 \
                --lineage land_plant

### END ###
