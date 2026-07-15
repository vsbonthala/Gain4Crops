#!/bin/bash
#SBATCH --job-name=PurgeHaplotigs
#SBATCH --output=purge_haplotigs.out
#SBATCH --error=purge_haplotigs.err
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --mem 200G
#SBATCH -p largemem
#SBATCH -t 7-00:00:00

# Get sample name
SAMPLE=$1

# Data Paths
ASSEMBLY=/assembling/"${SAMPLE}"/"${SAMPLE}"_output.fasta
R1=/assembling/"${SAMPLE}"/split_reads.1.fq.gz.clean.gz
R2=/assembling/"${SAMPLE}"/split_reads.2.fq.gz.clean.gz

# Tool Paths
gt=/myTools/gt-1.6.2-Linux_i386-64bit/bin/gt
minimap2=/myTools/miniconda3/envs/purge_haplotigs/bin/minimap2
samtools=/myTools/miniconda3/envs/purge_haplotigs/bin/samtools
purge_haplotigs=/myTools/miniconda3/envs/purge_haplotigs/bin/purge_haplotigs


# Map stLFR cleaned reads against drfat assembly using minimap2
echo "Mapping reads..."
#$minimap2 -ax sr -t 20 $ASSEMBLY $R1 $R2 > mapped-sr.sam
#$samtools view -u mapped-sr.sam | $samtools sort -@ 10 -m 10G -o mapped-sr.bam -T tmp.ali

# Purge haplotigs
echo "Stage 1 of purge_haplotigs..."
$purge_haplotigs hist -b mapped-sr.bam -g $ASSEMBLY -t 20

echo "Stage 2 of purge_haplotigs..."
$purge_haplotigs cov -i mapped-sr.bam.gencov -l 5  -m 40 -h 135

echo "Stage 3 of purge_haplotigs..."
$purge_haplotigs purge -g $ASSEMBLY -c coverage_stats.csv -t 20 -d -b mapped-sr.bam

