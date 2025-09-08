# This script converts a multi-tissue TPMs table into a single pivot table. Filter out genes with TPM<0.5.

import sys
import pandas as pd

# Read table
df = pd.read_csv("abundance.tpm", sep="\t", names=["Tissue", "TranscriptID", "TPM"], header=None)

# Get number of genes expressed with TPM >= 0.5
dfX = df[df["TPM"] >= 0.5]
X = dfX['TranscriptID'].nunique()
print("###########################")
print("Number of genes expressed with TPM >= 0.5 in atleast one Tissue: " + str(X))
print("###########################")

# Convert table into pivot table
df2 = dfX.pivot_table(index="TranscriptID", columns="Tissue", values="TPM")

print("Number of genes expressed with TPM >= 0.5 in each Tissue: ")
print((df2 >= 0.5).sum())
print("###########################")

# Write pivot table to file
df2.to_csv("abundance.tpm_pivot", sep="\t")

sys.exit()
