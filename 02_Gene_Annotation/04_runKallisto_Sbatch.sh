#!/bin/bash
#SBATCH --job-name=Kallisto
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --mem 20G
#SBATCH -p largemem
#SBATCH -t 2-00:00:00


# Create a folder to store all expression matrices
mkdir -p expression && cd expression


# Get Species Name
genome=$1
transcripts=../"$genome"__genome_Helixer.functions.IPScan.AA50.nonTE.transcripts.fa


# Tool path
kallisto=~/myTools/miniconda3/bin/kallisto
# URL: https://pachterlab.github.io/kallisto/manual


###################################################
### Step 1: Quantify gene expression in each tissue
###################################################

# Generate Kallisto index
$kallisto index -i kallisto_index $transcripts

# Quantify expression for each tissue. Depending on the species, we have RNA-Seq data for Leaf (_L)/Root (_R)/Stem (_S)/Flower (_F)
for out in CORE2_L, CORE2_R, CORE2_S
do
echo $out
mkdir -p $out
$kallisto quant -i kallisto_index -o $out --bias -b 100 --plaintext -t 20 "$out"_1.fq.gz "$out"_2.fq.gz

# Insert Name of tissue into the gene expression file
awk -v out="$out" '{print out"\t"$0}' "$out"/abundance.tsv > "$out"/abundance.tsv2
done

echo "Kallisto quantification is complete..."


#######################################################################
### Step 2: Get a single expression matrix for all genes across tissues
#######################################################################
# Concatenate abundance.tsv files of all samples
cat *_*/*.tsv2 | awk -F"\t" '{print $1"\t"$2"\t"$6}' | grep -v tpm > abundance.tpm

# Create a pivot table
python3 exp_getPivot.py

### END ###
