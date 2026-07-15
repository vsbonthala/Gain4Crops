# Genome Assembly and Assessment Pipeline

This repository contains a streamlined pipeline for *de novo* genome assembly, diploid assembly purging, and quality assessment. The workflow is divided into three main bash scripts designed to be run sequentially.

## 🧬 Pipeline Overview

1. **Assembly:** Initial *de novo* assembly using 10x Genomics Supernova.
2. **Purging:** Removing duplicate contigs/haplotigs from the diploid assembly using Purge Haplotigs.
3. **Assessment:** Evaluating the completeness of the curated assembly using BUSCO.

---

## 🛠️ Prerequisites

To run these scripts, ensure the following software is installed and available in your system's PATH or module system:

* **[Supernova](https://support.10xgenomics.com/de-novo-assembly/software/overview/welcome)** (10x Genomics)
* **[Purge Haplotigs](https://bitbucket.org/mroachawri/purge_haplotigs/src/master/)** (and its dependencies like Minimap2 and BEDTools)
* **[BUSCO](https://busco.ezlab.org/)** (Benchmarking Universal Single-Copy Orthologs)
* A job scheduler like **SLURM** (if running on a high-performance computing cluster).

---

## 🚀 Usage Instructions

The pipeline is split into three scripts. Execute them in the following order:

### Step 1: Genome Assembly (`script1.sh`)
This script runs the `stlfr2supernova_pipeline` and utilizes Supernova to generate a *de novo* pseudohaploid assembly from 10x linked-read data.

```bash
# Example execution (adjust for your job scheduler, e.g., sbatch)
sbatch script1.sh
