""" This script computes a phylogenetic tree for each of the HOG.
    Here, we will use: Single-copy-HOG, Single-copy-HOG_paralogs and Other-OGs only.
    The pipeline is as follows:
    1. Extract AA and Transcript (CDS) for each HOG using faSomeRecords
    2. Compute Multiple sequence alignment (MSA) for each of the HOG using AA sequences using Mafft
    3. Convert AA's MSA into a Codon-based alignment using PAL2NAL
    4. Estimate a phylogenetic tree using Codon-based alignment of each HOG using RAxML

    Note: Activate conda env SpeciesTree before running this script
"""

import os, csv, sys
import itertools
from multiprocessing import Process, Pool
from Bio import SeqIO
from Bio import AlignIO
from Bio.Align.Applications import ClustalwCommandline
from Bio.Align.Applications import MuscleCommandline

ROOTDIR = "~/gain4crops/analysis/orthology/Species_Tree_Inference"
os.chdir(ROOTDIR)


og = {}
#ogIDs = set()
with open("hogTab2.tab") as fhd:
        for entry in fhd:
                entry = entry.strip().split("\t")

                if entry[0] == "HOG ID":
                        continue

                try:
                        og[entry[0]].append(entry[3])
                except KeyError:
                        og[entry[0]] = [entry[3]]


# read protein sequences for all species into a dict
AA_file = open("AllSpecies_AA.fa")
AA_seq = SeqIO.to_dict(SeqIO.parse(AA_file, "fasta"))

# read transcript sequences for all species into a dict
Tran_file = open("AllSpecies_Transcripts.fa")
Trans_seq = SeqIO.to_dict(SeqIO.parse(Tran_file, "fasta"))


def myPipeline(ogid):
        """ This function implements: MSA of given AA sequences, converts AA MSA into CDS/Transcript MSA and estimates phylogenetic tree. """

        # Program paths
        raxmlHPC = "/usr/bin/raxmlHPC"
        pal2nal = "/usr/bin/pal2nal.pl"
        mafft = "/usr/bin/mafft"

        ogid = ogid
        print("Running Pipeline for " + ogid)

        # Create a new folder for each OG
        if not os.path.exists(ROOTDIR+"/Single-copy-HOG-Paralogs/"+ogid):
                os.makedirs(ROOTDIR+"/Single-copy-HOG-Paralogs/"+ogid)

        # Define output file for convenience
        ogAA = ROOTDIR+"/Single-copy-HOG-Paralogs/"+ogid + "/" + ogid + ".AA.fa"
        ogAAaln = ROOTDIR + "/Single-copy-HOG-Paralogs/" + ogid + "/" + ogid + ".AA.aln"
        ogTxn = ROOTDIR+"/Single-copy-HOG-Paralogs/"+ogid + "/" + ogid + ".Transcript.fa"
        ogTxnalnNoGap = ROOTDIR+"/Single-copy-HOG-Paralogs/"+ogid + "/" + ogid + ".AA.pal2nal.noGap.aln"
        ogTxnalnGap = ROOTDIR + "/Single-copy-HOG-Paralogs/" + ogid + "/" + ogid + ".AA.pal2nal.Gap.aln"

        # Extract AA sequences for each OG and create a fasta file
        tmp_seq = {}
        with open(ogAA, "w") as ghd:
                tmp = og[ogid]
                for ID in tmp:
                        if ID in AA_seq.keys():
                                tmp_seq[ID] = AA_seq[ID]
                SeqIO.write(tmp_seq.values(), ghd, 'fasta')

        # Extract Transcript sequences for each OG and create a fasta file
        txn_seq = {}
        with open(ogTxn, "w") as hhd:
                TMP = og[ogid]
                for ID in TMP:
                        if ID in Trans_seq.keys():
                                txn_seq[ID] = Trans_seq[ID]
                SeqIO.write(txn_seq.values(), hhd, 'fasta')

        # Perform MSA of AA sequences using MAFFT
        os.system(mafft + ' --auto --thread 2 ' + ogAA + ' > ' + ogAAaln)

        # Convert AA MSA into Transcript MSA. Get alignments with gaps and no gaps
        os.system(pal2nal + ' ' + ogAAaln + ' ' + ogTxn + ' -output fasta -nogap > ' + ogTxnalnNoGap)
        os.system(pal2nal + ' ' + ogAAaln + ' ' + ogTxn + ' -output fasta > ' + ogTxnalnGap)

        # Run RAxML
        wdir = ROOTDIR + "/Single-copy-HOG-Paralogs/" + ogid  # Write RAxML output to the same folder

        # RAxML on Transcript alignments (gaps)
        os.system(raxmlHPC + ' -m GTRGAMMA -f a -x 1979 -p 1979 -N 200 -T 2 ' + ' -w ' + wdir + ' -n TxnGaps_'+ogid + ' -s ' + ogTxnalnGap)

        print("Pipeline completed for " + ogid)



# Set the number of threads to use in parallel
num_threads = 6


ogIDs = [line.rstrip('\n') for line in open("Single-copy-HOG.ID")]

with Pool(num_threads) as pool:
# Map myPipeline function on every element of ogs in parallel
        results = pool.map(myPipeline, list(ogIDs))


sys.exit()
