# GAIN4CROPS

This repository contains pipelines for computing *de novo* genome assemblies and annotation, inferring species tree, investigation of whole-genome duplications and phylogenetic association mapping of genotype (CNV of HPGs and MapMan BINs) against phenotype (CCP) as part of the Gain4Crops project (`http://gain4crops.eu`).

---

## 🧬 Pipeline Overview

The workflow is divided into three main stages:

### 1. Genome Assembly & Purging (`/00_Genome_Assembly`)
* **Step 1 (`runSupernova_Sbatch.sh`):** *De novo* assembly using Supernova.
* **Step 2 (`runPurgeHaplotigs_SBATCH.sh`):** Haplotig purging using Purge Haplotigs.
* **Step 3 (`runBUSCO_Sbatch.sh`):** Completeness check with BUSCO.

### 2. Repeat & Gene Annotation (`/01_Repeat_Annotation and /02_Gene_Annotation`)
* **Step 1 (`runEDTA_Sbatch.sh`):** Transposable element masking with EDTA.
* **Step 2 (`00_runHelixer_Sbatch.sh`):** *De novo* gene prediction using Helixer.
* **Step 3 (`01_runFunctional_Annotation_Sbatch.sh`):** Functional annotation with InterProScan.
* **Step 4 (`02_filter_annotation.sh`):** Filtering TE-related genes using Pfam domains.
* **Step 5 (`04_runKallisto_Sbatch.sh`):** RNA-Seq gene expression quantification.
* **Step 6 (`03_runBUSCO_Sbatch.sh`):** Completeness check of predicted proteins.

### 3. Species Tree Inference (`/03_Species_Tree_Inference`)
* **Step 1 & 2 (`01_runOrthofinder_Sbatch.sh`, `02_Classify_HOGs.py`):** HOG identification and copy-number classification.
* **Step 3 (`03_Compute_Phylogenetic_Trees_HOGs.py`):** Compute gene trees for each HOG.
* **Step 4 (`04_SpeciesTree_MSC_Approach.sh`):** Compute a species tree using MSC approach.
* **Step 5 (`05_SpeciesTree_Partition_SuperMatrix.sh`):** Compute a species tree using super-matrix based approach.

### 4. Whole Genome Duplications (`/04_Whole_Genome_Duplications`)
* **Step 1 (`runWGD_SBATCH.sh`):** Compute paralogous clusters and Ks values for each duplicate gene pair.
* **Step 2 (`Identify_Ks_Peaks_KDE.py`):** Identify prominent Ks peaks corresponding to whole-genome duplications.
* **Step 3 (`runTree2GD.sh`):** Perform gene tree-species tree reconciliation to place whole-genome duplication events on species tree.

### 5. Interspecies Association Analysis (`/05_Interspecies_Association_Analysis`)
* **Step 1 (`PAM_Crunch_MapMan_BINS.R`):** Perform phylogenetic association mapping (PAM) to link genotype (CNVs of HOGs/MapMan BINs) against phenotype (CCP: CO2 Compensation Points)

---

## 🚀 Citation:


