# This file contains post-processing of Helixer's output after functional annotation:
# 1. Remove gene models producing protein sequences <50 amino acids
# 2. Find TE-related genes using PFAM IDs of TE-related genes (The list was curated for the SHAPE project) and Keywords of TE-related genes.
# 3. Create final Non-TE Genes with AA length >=50

# Inputs
genome="C_basalis"


# Tools paths
faSomeRecords=~/myTools/UCSCTOOLS/faSomeRecords
faSize=~/myTools/UCSCTOOLS/faSize


##############################################################################
### Step 1: Filter out gene models producing protein sequences <50 amino acids
##############################################################################
echo "Finding and excluding short gene models (<50 AA)..."
echo " "
date
echo " "
$faSize -detailed "$genome"_genome_Helixer.proteins.functions.fa > "$genome"_genome_Helixer.proteins.functions.fa_faSize

cat "$genome"_genome_Helixer.proteins.functions.fa_faSize | awk '$2>=50' | awk '{print $1}' > proteins_AA50.id
cat proteins_AA50.id | awk -F"." '{print $1}' > genes_AA50.id # Get gene IDs

$faSomeRecords "$genome"_genome_Helixer.transcripts.functions.fa proteins_AA50.id "$genome"_genome_Helixer.transcripts.functions.AA50.fa
$faSomeRecords "$genome"_genome_Helixer.proteins.functions.fa proteins_AA50.id "$genome"_genome_Helixer.proteins.functions.AA50.fa
grep -f genes_AA50.id "$genome"_genome_Helixer.functions.IPScan.gff > "$genome"_genome_Helixer.functions.IPScan.AA50.gff
date
echo " "


######################################################
### Step 2: Filter out gene models related to TE-genes
######################################################
echo "Finding and excluding gene models related to TE-genes (PFAM IDs)..."
echo " "
date
echo " "

selected_pfam_te=~/annotation/selected_pfam_te.txt
# Reference: https://www.nature.com/articles/s41586-020-2947-8

grep -f $selected_pfam_te "$genome"_genome_Helixer.functions.IPScan.AA50.gff > TE.gff

# Get Gene IDs of TE-related genes
cat TE.gff | awk '$3=="gene"' | awk '{print $9}' | awk -F";" '{print $1}' | sed 's/ID=//g' | sort | uniq > teGenes_PFAM.id

# Exclude TE-related genes using PFAM matches
grep -v -f teGenes_PFAM.id "$genome"_genome_Helixer.functions.IPScan.AA50.gff > nonTE1.gff
date
echo " "


######################################################
### Step 3: Keyword-based search
######################################################
echo "Finding and excluding gene models related to TE-genes (Keywords)..."
echo " "
date
echo " "
cat nonTE1.gff | grep -i "transpos" > teKeywords.txt
cat nonTE1.gff | grep -i "polyprotein" >> teKeywords.txt
cat nonTE1.gff | grep -i "gypsy" >> teKeywords.txt
cat nonTE1.gff | grep -i "copia" >> teKeywords.txt
cat nonTE1.gff | grep -i "HAT domain" >> teKeywords.txt
cat nonTE1.gff | grep -i "HAT family" >> teKeywords.txt
cat nonTE1.gff | grep -i "HAT dimeri" >> teKeywords.txt
cat nonTE1.gff | grep -i "CACTA" >> teKeywords.txt
cat nonTE1.gff | grep -i "Mutator" >> teKeywords.txt
cat nonTE1.gff | grep -i "RNA-directed DNA polymerase" >> teKeywords.txt
cat nonTE1.gff | grep -i "reverse transcriptase" >> teKeywords.txt

# Get Gene IDs of TE-related genes
cat teKeywords.txt | awk '$3=="gene"' | awk '{print $9}' | awk -F";" '{print $1}' | sed 's/ID=//g' | sort | uniq > teGenes_Keywords.id

# Exclude TE-related genes using Keyword matches
grep -v -f teGenes_Keywords.id nonTE1.gff > "$genome"_genome_Helixer.functions.IPScan.AA50.nonTE.gff
date
echo " "


############################################
### Step 4: Prepare final non-TE gene models
############################################
echo "Finding and excluding gene models related to TE-genes (Keywords)..."
echo " "
date
echo " "
cat "$genome"_genome_Helixer.functions.IPScan.AA50.nonTE.gff | awk '$3=="mRNA"' | awk '{print $9}' | awk -F";" '{print $1}' | sed 's/ID=//g' > genes_AA50_nonTE.id

$faSomeRecords "$genome"_genome_Helixer.transcripts.functions.fa genes_AA50_nonTE.id "$genome"_genome_Helixer.functions.IPScan.AA50.nonTE.transcripts.fa
$faSomeRecords "$genome"_genome_Helixer.proteins.functions.fa genes_AA50_nonTE.id "$genome"_genome_Helixer.functions.IPScan.AA50.nonTE.proteins.fa

date
echo " "
echo "Filtering complete..."

### END ###
