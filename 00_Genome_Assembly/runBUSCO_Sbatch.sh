#!/bin/bash
#SBATCH --job-name=BUSCO
#SBATCH --output=BUSCO.out
#SBATCH --error=BUSCO.err
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --mem 100G
#SBATCH -p largemem
#SBATCH -t 3-00:00:00

# Activate conda
eval "$(conda shell.bash hook)"
conda activate BUSCO

# BUSCO analysis on purge_haplotig's output (curated.fasta)
# Program paths
faSize=/myTools/miniconda3/bin/faSize
faSomeRecords=/myTools/miniconda3/bin/faSomeRecords
stats=/myTools/bbmap/stats.sh

$faSize -detailed curated.fasta > curated.fasta.sizes

cat curated.fasta.sizes | awk -F"\t" '$2>999' | awk '{print $1}' > curated_G1K.id

$faSomeRecords curated.fasta curated_G1K.id curated_G1K.fasta

$stats in=curated.fasta out=curated.fasta_stats addname=t extended=t
$stats in=curated_G1K.fasta out=curated_G1K.fasta_stats addname=t extended=t

mkdir -p busco_analysis
cd busco_analysis

for f in {1..1..1}
do
busco -i ../curated_G1K.fasta -o curated_G1K_embryophyta -l embryophyta_odb10 -c 20 -m genome > curated_G1K_embryophyta.log 2> curated_G1K_embryophyta.err
busco -i ../curated.fasta -o curated_embryophyta -l embryophyta_odb10 -c 20 -m genome > curated_embryophyta.log 2> curated_embryophyta.err

mkdir BUSCO_summaries

cp curated_embryophyta/short*.txt BUSCO_summaries
cp curated_G1K_embryophyta/short*.txt BUSCO_summaries

generate_plot.py -wd BUSCO_summaries

done
