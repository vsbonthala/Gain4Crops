#!/bin/bash

#SBATCH --mail-type all
#SBATCH --job-name=FunAnnot
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH -p normal
#SBATCH -t 21-00:00:00
#SBATCH -N 1
#SBATCH -n 30
#SBATCH --mem 20G

# USAGE: sbatch runFunAnnot_Sbatch.sh

# Activate MAKER's conda environment
eval "$(conda shell.bash hook)"
conda activate ~/miniconda3/envs/MAKER

# Ref: https://github.com/xvazquezc/genome_annotation_with_Maker2/blob/master/Maker2_protocol/Maker2_protocol.md#the-third-and-final-run

# Get inputs
genome="C_basalis"

echo "Species codes used for prefix "+ $genome
echo " "
###===============================================================###
# Set program variables
# MAKER Programs
map_gff_ids=~/myTools/maker3/bin/map_gff_ids
map_fasta_ids=~/myTools/maker3/bin/map_fasta_ids
maker_functional_gff=~/myTools/maker3/bin/maker_functional_gff
maker_functional_fasta=~/myTools/maker3/bin/maker_functional_fasta
ipr_update_gff=~/myTools/maker3/bin/ipr_update_gff

# Other programs
blastp=~/miniconda3/envs/MAKER/bin/blastp
ipscan=~/myTools/interproscan-5.57-90.0/interproscan.sh
gffread=~/myTools/gffread/gffread

# UniProt database/sequences downloaded on 29/August/2022
UniProt=~/myTools/uniprot/uniprot_sprot.fasta
UniProtDb=~/myTools/uniprot/uniprot_sprot.fasta_blastdb
###===============================================================###


#==================================================#
# Step 1: Extract Transcripts and Protein sequences
#==================================================#
echo " Extracting sequences - Transcripts and Protein..."
echo " "
date
echo " "
cat "$genome"_genome_Helixer.gff3 | awk '{print $0";"}' > "$genome"_genome_Helixer.gff # This is required to work with MAKER tools!

# Extract sequences. URL: http://ccb.jhu.edu/software/stringtie/gff.shtml#gffread
$gffread -w "$genome"_genome_Helixer.transcripts.fa -g "$genome"_genome.fa "$genome"_genome_Helixer.gff
$gffread -y "$genome"_genome_Helixer.proteins.fa -g "$genome"_genome.fa "$genome"_genome_Helixer.gff
date
echo " "


#==========================#
# Step 2: BLASTP Annotations
#==========================#
echo " "
echo "Performing BLASTP..."
date
echo " "
$blastp -db $UniProtDb -query "$genome"_genome_Helixer.proteins.fa -out "$genome"_genome_Helixer.proteins.fa.blastp \
        -num_threads 30 -outfmt 6 -evalue 1e-6 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -max_target_seqs 1
date
echo " "

echo "Adding BLASTP functional annotation to Helixer files.."
echo "gff.."
$maker_functional_gff $UniProt "$genome"_genome_Helixer.proteins.fa.blastp "$genome"_genome_Helixer.gff > "$genome"_genome_Helixer.functions.gff
echo "protein file..."
$maker_functional_fasta $UniProt "$genome"_genome_Helixer.proteins.fa.blastp "$genome"_genome_Helixer.proteins.fa > "$genome"_genome_Helixer.proteins.functions.fa
echo "transcript file..."
$maker_functional_fasta $UniProt "$genome"_genome_Helixer.proteins.fa.blastp "$genome"_genome_Helixer.transcripts.fa > "$genome"_genome_Helixer.transcripts.functions.fa
date


#================================#
# Step 3: InterProScan Annotations
#================================#
echo " "
echo "Running InterProScan..."
date
echo " "
$ipscan -i "$genome"_genome_Helixer.proteins.fa -o "$genome"_genome_Helixer.proteins.fa.ipscan.tsv -cpu 30 -dp -t p --goterms --pathways -iprlookup -f tsv -T /dev/shm \
        -appl TIGRFAM,SUPERFAMILY,Pfam #PANTHER,Gene3D,Hamap,Coils,SMART,CDD,PRINTS,SignalP_EUK,Pfam,MobiDBLite,PIRSF,TMHMM #,ProSiteProfiles,ProSitePatterns,ProDom
date
echo " "
echo "Adding InterProScan functional annotation to Helixer files.."
date
echo " "
$ipr_update_gff "$genome"_genome_Helixer.functions.gff "$genome"_genome_Helixer.proteins.fa.ipscan.tsv > "$genome"_genome_Helixer.functions.IPScan.gff
date
echo " "
echo "Annotation Complete..."
### END ###
