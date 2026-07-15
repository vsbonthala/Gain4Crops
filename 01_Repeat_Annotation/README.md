# Repeat Annotation Pipeline using EDTA

This project contains a streamlined workflow for identifying, classifying, and masking transposable elements and repetitive regions in a genome assembly. The pipeline runs the **EDTA (Extensive de-novo TE Annotator)** tool on a purged genome assembly.

## 🧬 Pipeline Overview

The pipeline executes a single primary script, `edta.sh`, which performs the following tasks:
1. **Structural Identification:** Runs structural search tools for LTRs, TIRs, and Helitrons.
2. **Homology Classification:** Resolves overlapping predictions and classifies TEs using a curated library.
3. **Repeat Masking:** Masks the input genome using the newly constructed, non-redundant TE library.

---

## 🛠️ Prerequisites

To run this script, ensure the following software is installed and accessible in your environment:

* **EDTA (Extensive de-novo TE Annotator)** (Recommended to run via Docker, Singularity, or Conda)
* **SLURM** (or your respective high-performance computing job scheduler)

---

## 🚀 Usage Instructions

Prior to running the script, make sure to edit the variables inside `runEDTA_Sbatch.sh` to match your specific system paths, cluster allocation accounts, and genome species details (e.g., `-type plant` or `-type animal`).

### Execute the Annotation (`edta.sh`)

```bash
sbatch edta.sh
```

* **Input:** The curated, purged genome assembly file (`.fasta` or `.fa`) resulting from the previous purging step.
* **Output:** * A comprehensive non-redundant TE library (`[genome_name].EDTA.TElib.fa`).
  * A TE-masked genome file (`[genome_name].EDTA.anno/[genome_name].fa.masked`).
  * GFF3 files containing coordinate annotations of the transposable elements.
