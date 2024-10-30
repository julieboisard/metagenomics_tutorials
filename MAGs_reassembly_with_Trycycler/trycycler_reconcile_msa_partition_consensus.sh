#!/bin/bash -l

# run trycycler reconcile on cluster of interest

reads=reads/reads_qc_MAG/MAG_flye_filtlong.fastq
outdir=MAG_cluster
threads=30

# this step is interactive
trycycler reconcile --reads $reads  --cluster_dir $outdir/cluster_001 --threads $threads

# final steps: reads mapping and consensus sequence

trycycler msa --cluster_dir $outdir/cluster_001 --threads $threads

trycycler partition --reads $reads --cluster_dirs $outdir/cluster_001 --threads $threads

trycycler consensus --cluster_dir $outdir/cluster_001 --threads $threads