# Genome Assembly and Assessment Pipeline

This project contains a streamlined pipeline for *de novo* genome assembly, diploid assembly purging, and quality assessment. The workflow is divided into three main bash scripts designed to be run sequentially.

## 🧬 Pipeline Overview

1. **Assembly:** Initial *de novo* assembly using 10x Genomics Supernova.
2. **Purging:** Removing duplicate contigs/haplotigs from the diploid assembly using Purge Haplotigs.
3. **Assessment:** Evaluating the completeness of the curated assembly using BUSCO.

---

## 🛠️ Prerequisites

To run these scripts, ensure the following software is installed and available in your system's PATH or cluster module system:

* **Supernova** (10x Genomics)
* **Purge Haplotigs** (including dependencies like Minimap2 and BEDTools)
* **BUSCO** (Benchmarking Universal Single-Copy Orthologs)
* **SLURM** (or your respective high-performance computing job scheduler)

---

## 🚀 Usage Instructions

Execute the scripts in the following order. Make sure to edit each script prior to execution to match your specific file paths, cluster allocation accounts, and email addresses for logging.

### Step 1: Genome Assembly (`script1.sh`)
This script utilizes Supernova to generate a *de novo* pseudohaploid assembly from linked-read data.

```bash
sbatch script1.sh
