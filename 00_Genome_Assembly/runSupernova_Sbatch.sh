#!/bin/bash
#SBATCH --job-name=Supernova
#SBATCH --chdir=assembling/
#SBATCH --output=slurm_log/Supernova.out
#SBATCH --error=slurm_log/Supernova.err
#SBATCH -N 1
#SBATCH -n 80
#SBATCH --mem 800G
#SBATCH -p largemem
#SBATCH -t 12-00:00:00


home=$PWD
echo $home
cd $home

# Run stlfr2supernova_pipeline and get pseudohap assembly.
date

# This step requires a profile file containing details about read files and primers used to generate stLFR PE reads.
~/myTools/stlfr2supernova_pipeline/run.sh >& stlfr2supernova_pipeline.log

echo "Supernova mkoutput with style=pseudohap2..."
date
tag=`date +_%m_%d_%H_%M_%S`
supernova mkoutput  --minsize=$MINSIZE \
                    --style=pseudohap2 \
                    --asmdir="./"$PROJECT_NAME"/outs/assembly" \
                    --outprefix="$PROJECT_NAME""_output_haplotype" \
                    >supernova_mkoutput_haplotype_"$tag".log  2>supernova_mkoutput_haplotype_"$tag".err || exit 1
                    
echo "done step 4 ..."
echo "stlfr2supernova_pipeline completed..."
date
