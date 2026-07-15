# Species Tree Inference Pipeline (HOGs & Phylogenomics)

This project contains a multi-step phylogenomics pipeline designed to infer a species tree starting from proteome sequences. The workflow runs through orthology inference, classification, alignment, codon-aware translation, individual gene tree reconstruction, and finally, species tree estimation using both **coalescent-based** and **supermatrix-based** approaches.

## 🧬 Pipeline Overview

1. **Orthology Inference:** Identify Hierarchical Orthologous Groups (HOGs) using **OrthoFinder**.
2. **HOG Classification:** Classify the inferred HOGs into distinct groups (e.g., single-copy, multi-copy).
3. **Sequence Extraction:** Extract protein sequences for target HOGs using Python-based fasta record parsers.
4. **Multiple Sequence Alignment (MSA):** Align protein sequences using **MAFFT**.
5. **Codon Alignment:** Convert the protein alignments back to nucleotide alignments using **PAL2NAL**.
6. **Gene Tree Reconstruction:** Construct individual gene/HOG trees using **RAxML**.
7. **Species Tree Inference (Two Approaches):**
   * **Multi-Species Coalescent (MSC) Approach:** Infer a species tree using **ASTRAL-pro3** by feeding in all reconstructed HOG trees.
   * **Supermatrix-based (Concatenation) Approach:** Concatenate single-copy HOG alignments, run partition scheme selection using **PartitionFinder**, and reconstruct the final species tree using **RAxML**.

---

## 🛠️ Prerequisites

To run these scripts, ensure the following software is installed and available in your environment or loaded via your cluster module system:

* **OrthoFinder**
* **MAFFT**
* **PAL2NAL**
* **RAxML** (or `raxmlHPC` / `raxml-ng`)
* **ASTRAL-pro3**
* **PartitionFinder**
* **Python 3** (with `Biopython` for FASTA/SeqRecord parsing, and sequence concatenation scripts)
* **SLURM** (or your respective high-performance computing job scheduler)

---

## 🚀 Usage Instructions

Execute the scripts in the following order. Ensure you edit the header parameters and internal paths in each script before submitting them to your cluster.

### Step 1: Orthology Inference (`01_runOrthofinder_Sbatch.sh`)
This script groups input proteomes (FASTA files of predicted proteins) into orthologous groups and identifies Hierarchical Orthologous Groups (HOGs).

```bash
sbatch 01_runOrthofinder_Sbatch.sh
```

* **Input:** A directory containing protein FASTA files for all target species.
* **Output:** OrthoFinder results, specifically the `Phylogenetic_Hierarchical_Orthogroups/N0.tsv` file mapping genes to HOGs.

### Step 2: HOG Classification (`02_Classify_HOGs.py`)
This script parses the OrthoFinder output to categorize HOGs based on duplication history and copy number (e.g., isolating strict single-copy orthologs, low-copy, or multi-copy families).

```bash
sbatch 02_Classify_HOGs.py
```

* **Input:** The `N0.tsv` file from Step 1.
* **Output:** Flat text files or TSVs listing HOG IDs categorized by class (e.g., `single_copy_hogs.txt`).

### Step 3: Compute Phylogenetic Trees for each HOG (`03_Compute_Phylogenetic_Trees_HOGs.py`)
For each classified HOG of interest, this script uses Python's `SeqIO` (FastaRecords) to extract the corresponding protein and matching nucleotide sequences.

```bash
python3 03_Compute_Phylogenetic_Trees_HOGs.py
```

* **Input:** * Classified HOG lists (from Step 2).
  * Original protein and coding sequence (CDS) FASTA files.
* **Output:** Best-scoring ML tree files (`RAxML_bestTree.[HOG_ID]`) for each gene family.

---

### Step 4: Species Tree via Multi-Species Coalescent (`4_SpeciesTree_MSC_Approach.sh`)
This script pools individual gene trees and uses **ASTRAL-pro3** to infer a species tree. ASTRAL-pro3 is designed specifically to handle multi-copy gene families (paralogs and orthologs), accounting for gene duplication and loss.

```bash
bash 4_SpeciesTree_MSC_Approach.sh
```

* **Input:** A concatenated file containing all individual gene trees generated in Step 6 (e.g., `all_gene_trees.tre`).
* **Output:** A coalescent-based species tree in Newick format.

### Step 5: Species Tree via Concatenation (`05_SpeciesTree_Partition_SuperMatrix.sh`)
This script performs a traditional supermatrix-based phylogenomics analysis using only high-confidence **single-copy HOGs**:
1. **Concatenation:** Glues the single-copy codon alignments end-to-end into a single super-matrix.
2. **Partitioning:** Uses **PartitionFinder** to define the optimal partitioning scheme and select evolutionary models (e.g., separating by gene or codon positions).
3. **Reconstruction:** Performs a partitioned ML analysis using **RAxML** on the supermatrix.

```bash
bash 05_SpeciesTree_Partition_SuperMatrix.sh
```

* **Input:** Codon-aligned FASTA files for single-copy HOGs.
* **Output:** * Concatenated supermatrix file (e.g., PHYLIP or FASTA format).
  * PartitionFinder configuration and output files.
  * A resolved maximum-likelihood species tree based on the supermatrix.
