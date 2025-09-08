# This file contains commands/code used to compute the species tree using a multi-species coalescent approach using:
# 75 Single-copy HOGs and 5515 Single-copy HOGs with paralogs, and combined a total of 5590 HOGs
# https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral-pro3.md

ASTRAL="~/tools/ASTER/bin/astral-pro3"


# Species tree inference using 75 HOGs
cat Single-copy-HOG/N0.HOG*/RAxML_bestTree.TxnGaps_N0.HOG* > Single-copy-HOG.bestTree.tre
cat hogTab2.tab | awk -F"\t" '$8=="Single-copy-HOG"' | awk '{print $4"\t"$7}' > Single-copy-HOG.ID.map

$ASTRAL --input Single-copy-HOG.bestTree.tre --mapping Single-copy-HOG.ID.map --thread 1 --root A_vulgaris --output 75_Single-copy-HOG.bestTree.SpsTree.u0.tre -u 0 &> 75_Single-copy-HOG.bestTree.SpsTree.u0.log
$ASTRAL --input Single-copy-HOG.bestTree.tre --mapping Single-copy-HOG.ID.map --thread 1 --root A_vulgaris --output 75_Single-copy-HOG.bestTree.SpsTree.u1.tre -u 1 &> 75_Single-copy-HOG.bestTree.SpsTree.u1.log
$ASTRAL --input Single-copy-HOG.bestTree.tre --mapping Single-copy-HOG.ID.map --thread 1 --root A_vulgaris --output 75_Single-copy-HOG.bestTree.SpsTree.u2.tre -u 2 &> 75_Single-copy-HOG.bestTree.SpsTree.u2.log
$ASTRAL --input Single-copy-HOG.bestTree.tre --mapping Single-copy-HOG.ID.map --thread 1 --root A_vulgaris --output 75_Single-copy-HOG.bestTree.SpsTree.u3.tre -u 3 &> 75_Single-copy-HOG.bestTree.SpsTree.u3.log
mv freqQuad.csv 75_Single-copy-HOG.bestTree.SpsTree.u3.freqQuad.csv


# Species tree inference using 5515 HOGs
cat Single-copy-HOG-Paralogs/N0.HOG*/RAxML_bestTree.TxnGaps_N0.HOG* > Single-copy-HOG-Paralogs.bestTree.tre
cat hogTab2.tab | awk -F"\t" '$8=="Single-copy-HOG-Paralogs"' | awk '{print $4"\t"$7}' > Single-copy-HOG-Paralogs.ID.map

$ASTRAL --input Single-copy-HOG-Paralogs.bestTree.tre --mapping Single-copy-HOG-Paralogs.ID.map --thread 6 --root A_vulgaris --output 5515_Single-copy-HOG-Paralogs.bestTree.SpsTree.u0.tre -u 0 &> 5515_Single-copy-HOG-Paralogs.bestTree.SpsTree.u0.log
$ASTRAL --input Single-copy-HOG-Paralogs.bestTree.tre --mapping Single-copy-HOG-Paralogs.ID.map --thread 6 --root A_vulgaris --output 5515_Single-copy-HOG-Paralogs.bestTree.SpsTree.u1.tre -u 1 &> 5515_Single-copy-HOG-Paralogs.bestTree.SpsTree.u1.log
$ASTRAL --input Single-copy-HOG-Paralogs.bestTree.tre --mapping Single-copy-HOG-Paralogs.ID.map --thread 6 --root A_vulgaris --output 5515_Single-copy-HOG-Paralogs.bestTree.SpsTree.u2.tre -u 2 &> 5515_Single-copy-HOG-Paralogs.bestTree.SpsTree.u2.log
$ASTRAL --input Single-copy-HOG-Paralogs.bestTree.tre --mapping Single-copy-HOG-Paralogs.ID.map --thread 6 --root A_vulgaris --output 5515_Single-copy-HOG-Paralogs.bestTree.SpsTree.u3.tre -u 3 &> 5515_Single-copy-HOG-Paralogs.bestTree.SpsTree.u3.log
mv freqQuad.csv 5515_Single-copy-HOG-Paralogs.bestTree.SpsTree.u3.freqQuad.csv


# Species tree inference using 5590 HOGs
cat Single-copy-HOG.bestTree.tre Single-copy-HOG-Paralogs.bestTree.tre > 5590_HOGs_AllSps.bestTree.tre
cat Single-copy-HOG.ID.map Single-copy-HOG-Paralogs.ID.map > Single-copy-HOG-Paralogs.ID.map

$ASTRAL --input 5590_HOGs_AllSps.bestTree.tre --mapping 5590_HOGs_AllSps.ID.map --thread 6 --root A_vulgaris --output 5590_HOGs_AllSps.bestTree.SpsTree.u0.tre -u 0 &> 5590_HOGs_AllSps.bestTree.SpsTree.u0.log
$ASTRAL --input 5590_HOGs_AllSps.bestTree.tre --mapping 5590_HOGs_AllSps.ID.map --thread 6 --root A_vulgaris --output 5590_HOGs_AllSps.bestTree.SpsTree.u1.tre -u 1 &> 5590_HOGs_AllSps.bestTree.SpsTree.u1.log
$ASTRAL --input 5590_HOGs_AllSps.bestTree.tre --mapping 5590_HOGs_AllSps.ID.map --thread 6 --root A_vulgaris --output 5590_HOGs_AllSps.bestTree.SpsTree.u2.tre -u 2 &> 5590_HOGs_AllSps.bestTree.SpsTree.u2.log
$ASTRAL --input 5590_HOGs_AllSps.bestTree.tre --mapping 5590_HOGs_AllSps.ID.map --thread 6 --root A_vulgaris --output 5590_HOGs_AllSps.bestTree.SpsTree.u3.tre -u 3 &> 5590_HOGs_AllSps.bestTree.SpsTree.u3.log
mv freqQuad.csv 5590_HOGs_AllSps.bestTree.SpsTree.u3.freqQuad.csv

### END ###
