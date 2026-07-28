
# Phylogenetic Association Mapping (PAM)

This directory contains a pipeline for performing PAM to link the genotype (gene copy numbers of HOGs and MapMan BINs) against the phenotype, CCP (CO2 Compensation Point).


## 🧬 Pipeline Overview

1. **Normalize the copy number variations**
2. **Perform PAM**

---


## 🚀 Usage Instructions

Execute the scripts in the following order. Make sure to edit each script prior to execution to match your specific file paths, cluster allocation accounts, and email addresses for logging.

### Step 1: Genome Assembly (runSupernova_Sbatch.sh)

```bash
Rscript --vanilla PAM_Crunch_MapMan_BINS.R
```

* **Input:** MapMan BIN Counts for each species: rows: MapMan BINs, columns: Species.
* **Output:** List of associated MapMan BIN IDs with p-values
