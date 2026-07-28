# Genome Assembly and Assessment Pipeline

This directory contains a streamlined pipeline for *de novo* genome assembly, assembly purging, and quality assessment. The workflow is divided into three main bash scripts designed to be run sequentially.

## 🧬 Pipeline Overview

1. **Assembly:** Initial *de novo* assembly using Supernova assembler (10X Genomics).
2. **Purging:** Removing duplicate contigs/haplotigs from the diploid assembly using Purge Haplotigs.
3. **Assessment:** Evaluating the completeness of the curated assembly using BUSCO.

---

## 🛠️ Prerequisites

To run these scripts, ensure the following software is installed and available in your system's PATH or cluster module system:

* **Supernova** (10X Genomics)
* **purge_haplotigs** (including dependencies like Minimap2 and samtools)
* **BUSCO** (Benchmarking Universal Single-Copy Orthologs)


---

## 🚀 Usage Instructions

Execute the scripts in the following order. Make sure to edit each script prior to execution to match your specific file paths, cluster allocation accounts, and email addresses for logging.

### Step 1: Genome Assembly (runSupernova_Sbatch.sh)
This script utilizes Supernova to generate a *de novo* pseudohaploid assembly from stLFR read data. Check https://github.com/BGI-Qingdao/stlfr2supernova_pipeline for more details on constructing a *de novo* pseudohaploid assembly from stLFR read data.

```bash
sbatch runSupernova_Sbatch.sh
```

* **Input:** Raw FASTQ files.
* **Output:** Supernova assembly outputs (FASTA files in `pseudohap2` style).

### Step 2: Assembly Purging (runPurgeHaplotigs_SBATCH.sh)
Highly heterozygous genomes can cause Supernova to assemble both alleles as separate contigs. This script uses purge_haplotigs to identify and remove redundant haplotigs, generating a curated primary assembly.

```bash
sbatch runPurgeHaplotigs_SBATCH.sh
```

* **Input:** The uncompressed FASTA file from Step 1 and aligned read BAM files.
* **Output:** A curated primary assembly FASTA and a separate FASTA containing the purged haplotigs.

### Step 3: Quality Assessment (runBUSCO_Sbatch.sh)
This script evaluates the completeness of the purged assembly by searching for highly conserved, single-copy orthologs.

```bash
sbatch runBUSCO_Sbatch.sh
```

* **Input:** The curated primary assembly FASTA from Step 2.
* **Output:** A summary text file containing the BUSCO scores (Complete, Duplicated, Fragmented, and Missing percentages).
