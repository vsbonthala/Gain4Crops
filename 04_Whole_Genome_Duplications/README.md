
# Whole-genome Duplications

This directory contains a multi-step pipeline designed to identify whole-genome duplication events using two complementary appraoches - analysis of **synonymous substitution rates (Ks)** and **Gene traa-species tree reconciliation**.


## 🧬 Pipeline Overview

1. **Identification of paralogous gene clusters:** Identify paralogous gene clusters using **wgd dmd**.
2. **Compute Ks for each duplicated gene pair:** Compute Ks values using **wgd ksd**.
3. **Identify prominent Ks peaks related to whole-genome duplication events in each species:** 
4. **Perform gene tree-species tree reconciliation:** Perform this analysis using gene trees constructed for all HOGs and species tree inferred using super-matrix based approach in earlier steps by feeding them to Tree2GD.
5. **Identify whole-genome duplication dervied gene pairs:** Identify duplicated gene pairs with Ks values of 0.41 - 0.68.

---

## 🛠️ Prerequisites

To run this analysis, ensure the following software is installed and available in your environment or loaded via your cluster module system:

* **wgd**
* **Python's KDE**

---

## 🚀 Usage Instructions

Execute the scripts in the following order. Ensure you edit the header parameters and internal paths in each script before submitting them to your cluster.

### Step 1: Identify paralogous gene clusters and compute Ks values for each pair of duplicated genes (`runWGD_SBATCH.sh`)

```bash
sbatch runWGD_SBATCH.sh SPECIES_NAME.CDS.fa
```

* **Input:** A directory containing a FASTA file with CDS sequences.
* **Output:** Creates wgd_dmd and wgd_ksd directories containing results generaed by this script.