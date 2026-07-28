#!/bin/bash

# Activate MAKER's conda environment
eval "$(conda shell.bash hook)"
conda activate Tree2GD

tree2gd="~/myTools/Tree2gd/tree2gd/software/Tree2GD"

tree="P1.raxml.support.rooted.nwk"
pavParalogsTrees="Single-Copy-HOG-PAV-Paralogs-bipartitions.paths"
pavParalogsMap="Single-copy-HOG-PAV-Paralogs.ID.map"

# Run tree2gd
$tree2gd $tree $pavParalogsMap $pavParalogsTrees run2 --species=3 --bp=80 --split_tree=false &> run3.log
# This will generates summarytable.txt and GDtype_stat.txt inside the 'run2' directory.
### END ###