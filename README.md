# GAIN4CROPS

An end-to-end pipeline for *de novo* genome assembly, structural and functional annotation, and species tree phylogenomics.

---

## 🧬 Pipeline Overview

The workflow is divided into three main stages:

### 1. Genome Assembly & Purging (`/assembly`)
* **Step 1 (`script1.sh`):** *De novo* assembly using Supernova.
* **Step 2 (`script2.sh`):** Haplotig purging using Purge Haplotigs.
* **Step 3 (`busco.sh`):** Completeness check with BUSCO.

### 2. Repeat & Gene Annotation (`/annotation`)
* **Step 1 (`edta.sh`):** Transposable element masking with EDTA.
* **Step 2 (`helixer.sh`):** *De novo* gene prediction using Helixer.
* **Step 3 (`interproscan.sh`):** Functional annotation with InterProScan.
* **Step 4 (`filter_te_genes.sh`):** Filtering TE-related genes using Pfam domains.
* **Step 5 (`quantify_expression.sh`):** RNA-Seq gene expression quantification.
* **Step 6 (`busco.sh`):** Completeness check of predicted proteins.

### 3. Species Tree Inference (`/phylogenomics`)
* **Step 1 & 2 (`01_orthofinder.sh`, `02_classify_hogs.sh`):** HOG identification and copy-number classification.
* **Step 3, 4, 5 & 6:** Sequence extraction, MAFFT alignment, PAL2NAL codon alignment, and individual RAxML gene tree building.
* **Step 7a (`07a_astral.sh`):** Coalescent-based species tree using ASTRAL-pro3.
* **Step 7b (`07b_supermatrix.sh`):** Supermatrix concatenation, PartitionFinder optimization, and RAxML species tree reconstruction.

---

## 🚀 How to Run

1. Clone the repository:
   ```bash
   git clone [https://github.com/your-username/gain4crop.git](https://github.com/your-username/gain4crop.git)
   ```
2. Navigate to the respective directory (`/assembly`, `/annotation`, or `/phylogenomics`).
3. Edit the SLURM headers (`#SBATCH`) and path variables inside the scripts.
4. Submit jobs in sequential order:
   ```bash
   sbatch <script_name>.sh
   ```
