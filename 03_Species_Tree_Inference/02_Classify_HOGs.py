""" This script prepares a table for HOGs with the following columns: HOG_ID | OG_ID | NO_OF_GENES | GENE_ID | Protein_Length | NO_OF_SPECIES | SPECIES_NAME | HOG_TYPE, 
    based on HOGs identified by OrthoFinder v2.5.4
    
    HOG_Type:
    1. Single-copy-HOG: Single-copy of the gene present in every species (39 species)
    2. Single-copy-HOG-Paralogs: A single copy of the gene is present in every species, but at least one species contains duplicated genes
    3. Single-copy-HOG-PAV: A single copy of the gene is absent in at least one species
    4. Single-copy-HOG-PAV-Paralogs: A single copy of the gene is absent in at least one species, and at least one species contains duplicated genes
    5. Species-specific-HOG: HOG is present in just a single species
    6. Unassigned-gene: Gene was not assigned to any HOG by OrthoFinder

"""

import os, sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns; sns.set_theme()


ROOTDIR = "~/g4c/downstream/Orthology_AllSps/Orthofinder_output"
os.chdir(ROOTDIR)


# Load genes and species mapping table

# Generated using the below shell code
# for f in *.fa; do echo $f;
# cat $f | grep ">" | awk '{print $1}' | sed 's/^>//g' | awk -v ff=$f '{print $1"\t"ff}' | sed 's/.fa//g' >> tmp.tab
# done

species = set() # List of 39 species
mapping = dict()
AllSpeciesGenes = set()  # Genes present in AllSpecies

with open("AllSpecies.mapping") as fh:
    for line in fh:
        (key, val) = line.strip("\n").split("\t") # GeneID | SpeciesName
        mapping[key] = val
        species.add(val)
        AllSpeciesGenes.add(key)

species = sorted(list(species))


# Get length of each protein sequence
faSize = dict()  # geneID | faSize
with open("AllSps.AA.faSize") as fh:
    for line in fh:
        (key, val) = line.strip("\n").split("\t") # GeneID | SpeciesName
        faSize[key] = val


# AllSpecies HOGs obtained from OrthoFinder
HogOg = {}  # HOG ID | OG ID
AllGenes = set()  # Genes assigned to HOGs by OrthoFinder

singleCopy = 0; singleCopyPAV = 0; singleCopyParalogs = 0; singleCopyPAVParalogs = 0; SpeciesSpecific = 0

hogTab1 = list()  # HOG ID | OG ID | NO OF GENES | NO OF SPECIES | HOG TYPE
hogTab2 = list()  # HOG ID | OG ID | NO OF GENES | GENE ID | Protein Length | NO OF SPECIES | SPECIES NAME | HOG TYPE

with open("Phylogenetic_Hierarchical_Orthogroups/N0.tsv") as ghd:
    next(ghd)  # Skip header
    for hog in ghd:
        hog = hog.strip("\n").replace(", ", "\t")
        hog = hog.split("\t")
        HogOg[hog[0]] = hog[1]  # Get HOG ID | OG ID
        tmp = hog[3:len(hog)]  # All genes of HOG
        genes = list(filter(None, tmp))  # Remove empty values (''). List of genes present in a HOG

        tmpSps = set() # Get list of Species present in a HOG

        for gene in genes:
            tmpSps.add(mapping[gene])
            AllGenes.add(gene)

        # Get different types of HOGs as defined at the start of this file
        if len(tmpSps) == 1:
            SpeciesSpecific += 1
            print(hog[0], hog[1], len(genes), len(tmpSps), "Species-Specific-HOG")
            hogTab1.append([hog[0], hog[1], len(genes), len(tmpSps), "Species-Specific-HOG"])

            for g in genes:
                hogTab2.append([hog[0], hog[1], len(genes), g, faSize[g], len(tmpSps), mapping[g], "Species-Specific-HOG"])


        if len(tmpSps) == 39 and len(genes) == 39:
            singleCopy += 1
            print(hog[0], hog[1], len(genes), len(tmpSps), "Single-copy-HOG")
            hogTab1.append([hog[0], hog[1], len(genes), len(tmpSps), "Single-copy-HOG"])

            for g in genes:
                hogTab2.append([hog[0], hog[1], len(genes), g, faSize[g], len(tmpSps), mapping[g], "Single-copy-HOG"])


        if len(tmpSps) == 39 and len(genes) > 39:
            singleCopyParalogs += 1
            print(hog[0], hog[1], len(genes), len(tmpSps), "Single-copy-HOG-Paralogs")
            hogTab1.append([hog[0], hog[1], len(genes), len(tmpSps), "Single-copy-HOG-Paralogs"])

            for g in genes:
                hogTab2.append([hog[0], hog[1], len(genes), g, faSize[g], len(tmpSps), mapping[g], "Single-copy-HOG-Paralogs"])


        if len(tmpSps) < 39:
            if len(tmpSps) == len(genes) and len(tmpSps) > 1:
                singleCopyPAV += 1
                print(hog[0], hog[1], len(genes), len(tmpSps), "Single-copy-HOG-PAV")
                hogTab1.append([hog[0], hog[1], len(genes), len(tmpSps), "Single-copy-HOG-PAV"])

                for g in genes:
                    hogTab2.append([hog[0], hog[1], len(genes), g, faSize[g], len(tmpSps), mapping[g], "Single-copy-HOG-PAV"])

            if len(tmpSps) != len(genes) and len(tmpSps) > 1:
                singleCopyPAVParalogs += 1
                print(hog[0], hog[1], len(genes), len(tmpSps), "Single-copy-HOG-PAV-Paralogs")
                hogTab1.append([hog[0], hog[1], len(genes), len(tmpSps), "Single-copy-HOG-PAV-Paralogs"])

                for g in genes:
                    hogTab2.append([hog[0], hog[1], len(genes), g, faSize[g], len(tmpSps), mapping[g], "Single-copy-HOG-PAV-Paralogs"])


print("# =====================")
print("# Print HOG statistics")
print("# =====================")
print("Number of genes present in All 39 Species: " + str(len(AllSpeciesGenes)))
print("Number of genes assigned to HOGs: " + str(len(AllGenes)))
print("Percentage of genes assigned to HOGs: " + str(len(AllGenes)/len(AllSpeciesGenes)*100))
print("Number of genes unassigned to HOGs: " + str(len(AllSpeciesGenes) - len(AllGenes)))
print("Percentage of genes unassigned to HOGs: " + str((len(AllSpeciesGenes) - len(AllGenes))/len(AllSpeciesGenes)*100))
print("\n")
print("Number of Single-copy HOGs: " + str(singleCopy))
print("Number of Single-copy HOGs with paralogs: " + str(singleCopyParalogs))
print("Number of Single-copy HOGs with PAV: " + str(singleCopyPAV))
print("Number of Single-copy HOGs with PAV & Paralogs: " + str(singleCopyPAVParalogs))
print("Number of Species-Specific HOGs: " + str(SpeciesSpecific))
print("# =====================")


# Write to files
hogTab1_df = pd.DataFrame(hogTab1, columns=["HOG ID", "OG ID", "NO OF GENES", "NO OF SPECIES", "HOG TYPE"])
hogTab1_df.to_csv("hogTab1.tab", sep="\t", index=False)

hogTab2_df = pd.DataFrame(hogTab2, columns=["HOG_ID", "OG_ID", "NO_OF_GENES", "GENE_ID", "Protein_Length", "NO_OF_SPECIES", "SPECIES_NAME", "HOG_TYPE"])
hogTab2_df.to_csv("hogTab2.tab", sep="\t", index=False)

hogTab2_df_pivot = pd.pivot_table(hogTab2_df, index=["HOG ID", "OG ID", "NO OF GENES", "NO OF SPECIES", "HOG TYPE"],
                                  columns="SPECIES NAME", values="GENE ID", aggfunc='count', fill_value=0)
hogTab2_df_pivot.reset_index(inplace=True)

print(hogTab2_df_pivot.head().to_string())
print(hogTab2_df_pivot.shape)
hogTab2_df_pivot.to_csv("hogTab2_Pivot.tab", sep="\t", index=False)

# Prepare data for PAM by deleting unwanted columns

# hogTab2_df_pivot['Cls_ID'] = hogTab2_df_pivot["NO_OF_GENES"] + '__' + hogTab2_df_pivot["NO_OF_SPECIES"] + '__' + hogTab2_df_pivot["Cluster_Type"]
# hogTab2_df_pivot.to_csv("hogTab2_Pivot3.tab", sep="\t", index=False)
hogTab2_df_pivot['HOG ID'] = hogTab2_df_pivot[['HOG ID', 'NO OF GENES', 'NO OF SPECIES']].astype(str).agg('_'.join, axis=1)
hogTab2_df_pivot.to_csv("hogTab2_Pivot.tab", sep="\t", index=False)

hogTab2_df_pivot = hogTab2_df_pivot.drop(["NO OF GENES", "NO OF SPECIES", "HOG TYPE"], axis=1)
hogTab2_df_pivot.to_csv("hogTab2_Pivot2.tab", sep="\t", index=False)

sys.exit()
