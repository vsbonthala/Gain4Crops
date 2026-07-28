# Compute a species tree using a partitioned super-matrix/alignment with their estimated evolutionary models, then compute the species tree.
# For this analysis, we used 75 Single-copy HOGs. The species tree estimated from this analysis will be used for all downstream analyses and the main manuscript.

mkdir -p Single-copy-HOG-Concat && cd Single-copy-HOG-Concat

# Create folders to save HOG's nucleotide MSAs.
mkdir -p aln fa

# Copy nucleotide alignments for each of 75 Single-copy HOGs
cp ../Single-copy-HOG/N0.HOG*..AA.pal2nal.Gap.aln aln/

# Step 1: Replace gene ID with Species name in individual MSA files
####################################################################
for f in aln/*.aln
do
echo $f
~/tools/seqkit replace -p "(.+)" -r '{kv}|$1' -k ../Single-copy-HOG.ID.map $f | awk -F"|" '{print $1}' > fa/"$f".fa
done


# Step 2: Concatenate all MSAs into a single super-matrix of MSAs.
##################################################################

# We will use AMAS.py concat to get the super-matrix of MSA
~/tools/AMAS/amas/AMAS.py concat -f fasta -d dna -i fa/*.fa

# Get summary of super-matrix MSA:
~/tools/AMAS/amas/AMAS.py summary -f fasta -d dna -i concatenated.out -o concatenated.out_summary -s


# Step 3: Get partitions and their best models using PartitionFinder with BEAST models
######################################################################################

mkdir -p beast_partitions && cd beast_partitions

python2 ~/tools/partitionfinder-2.1.1/PartitionFinder.py --processes=8 run1 &> run1.log

cd ..

# Step 4: Compute a species tree using identified partitions and their evolutionary models using RAxML-ng
#########################################################################################################
~/tools/raxml-ng/bin/raxml-ng --all --bs-trees 1000 --msa concatenated.phy --model beast_partitions/best_modes_from_partition_finder.txt --prefix P1 --seed 1234 --threads 10


### END ###