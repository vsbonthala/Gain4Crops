#!/bin/bash
#SBATCH --job-name=EDTA
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%k.err
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --mem 400G
#SBATCH -p largemem
#SBATCH -t 21-00:00:00

# Run EDTA

# Get purged genome assembly file
genome=$1

# conda activate EDTA

/myTools/EDTA/EDTA.pl \
        --genome $genome \
        --curatedlib /myTools/RepBase_Viridiplantae.fa \
        --sensitive 1 \
        --anno 1 \
        --repeatmodeler /myTools/RepeatModeler-2.0.3 \
        --repeatmasker /myTools/RepeatMasker \
        --threads 20 >& edta.log
