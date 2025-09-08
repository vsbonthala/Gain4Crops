#!/bin/bash

#SBATCH --mail-type all
#SBATCH --job-name=BUSCO
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --mem 20G
#SBATCH -p largemem
#SBATCH -t 2-00:00:00

# Activate BUSCO's conda environment
eval "$(conda shell.bash hook)"
conda activate BUSCO

# Get species name
genome="C_basalis"


# BUSCO analysis on raw and final gene annotation

mkdir -p busco_analysis && busco_analysis


# Get Transcript and protein file names
RawTrans=../"$genome"_genome_Helixer.transcripts.functions.fa
Raw50Trans=../"$genome"_genome_Helixer.transcripts.functions.AA50.fa
FinalTrans=../"$genome"_genome_Helixer.functions.IPScan.AA50.nonTE.transcripts.fa

RawProt=../"$genome"_genome_Helixer.proteins.functions.fa
Raw50Prot=../"$genome"_genome_Helixer.proteins.functions.AA50.fa
FinalProt=../"$genome"_genome_Helixer.functions.IPScan.AA50.nonTE.proteins.fa


echo " "
echo "BUSCO on RawTrans annotation..."
date
echo " "
busco -i $RawTrans -o RawTrans -l embryophyta_odb10 -c 20 -m transcriptome > RawTrans_embryophyta.log 2> RawTrans_embryophyta.err
date
echo " "
echo "BUSCO on Raw50Trans annotation..."
echo " "
date
busco -i $Raw50Trans -o Raw50Trans -l embryophyta_odb10 -c 20 -m transcriptome > Raw50Trans_embryophyta.log 2> Raw50Trans_annot_embryophyta.err
echo " "
date
echo " "
echo "BUSCO on FinalTrans annotation..."
echo " "
date
echo " "
busco -i $FinalTrans -o FinalTrans -l embryophyta_odb10 -c 20 -m transcriptome > FinalTrans_embryophyta.log 2> FinalTrans_annot_embryophyta.err
echo " "
date
echo " "
echo "BUSCO on RawProt annotation..."
echo " "
date
echo " "
busco -i $RawProt -o RawProt -l embryophyta_odb10 -c 20 -m protein > RawProt_embryophyta.log 2> RawProt_annot_embryophyta.err
date
echo " "
echo "BUSCO on Raw50Prot annotation..."
echo " "
date
echo " "
busco -i $Raw50Prot -o Raw50Prot -l embryophyta_odb10 -c 20 -m protein > Raw50Prot_embryophyta.log 2> Raw50Prot_annot_embryophyta.err
date
echo " "
echo "BUSCO on FinalProt annotation..."
echo " "
date
echo " "
busco -i $FinalProt -o FinalProt -l embryophyta_odb10 -c 20 -m protein > FinalProt_embryophyta.log 2> FinalProt_annot_embryophyta.err
date
echo " "
echo "Generating BUSCO plot..."
echo " "
date
echo " "

mkdir BUSCO_summaries

cp Raw*/short*.txt BUSCO_summaries
cp Final*/short*.txt BUSCO_summaries

generate_plot.py -wd BUSCO_summaries
date
echo " "
echo "BUSCO complete..."

### END ###
