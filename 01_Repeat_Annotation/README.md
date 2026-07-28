# Repeat Annotation Pipeline

This project contains a streamlined workflow for identifying, classifying, and masking transposable elements and repetitive regions in a genome assembly. The pipeline runs the **EDTA (Extensive de-novo TE Annotator)** tool on a purged genome assembly.

## 🧬 Pipeline Overview

The pipeline executes a single primary script, `runEDTA_Sbatch.sh`, which performs the following tasks:
1. **Structural Identification:** Runs structural search tools for LTRs, TIRs, and Helitrons.
2. **Homology Classification:** Resolves overlapping predictions and classifies TEs using a curated library.
3. **Repeat Masking:** Masks the input genome using the newly constructed, non-redundant TE library.

---

## 🛠️ Prerequisites

To run this script, ensure the following software is installed and accessible in your environment:

* **EDTA (https://github.com/oushujun/EDTA)**
* **RepeatModeler (https://github.com/Dfam-consortium/RepeatModeler)**
* **RepeatMasker (https://github.com/Dfam-consortium/RepeatMasker)**

---

## 🚀 Usage Instructions

Prior to running the script, make sure to edit the variables inside `runEDTA_Sbatch.sh` to match your specific system paths, cluster allocation accounts, and genome species details.

### Execute the Annotation (`runEDTA_Sbatch.sh`)

```bash
sbatch runEDTA_Sbatch.sh
```

* **Input:** The curated, purged genome assembly file (`.fa`) resulting from the previous purging step.
* **Output:** * A comprehensive non-redundant TE library (`[genome_name].EDTA.TElib.fa`).
  * A TE-masked genome file (`curated.fa.mod.MAKER.masked`).
  * GFF3 files containing coordinate annotations of the transposable elements (`curated.fa.mod.EDTA.TEanno.gff3`).
  * Summary statistics file containing list of identified repeat types (`curated.fa.mod.EDTA.TEanno.sum`).
