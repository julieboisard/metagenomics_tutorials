#!/bin/bash -l

threads=30 # change as appropriate for your system
assemblies=MAG_assemblies
reads=reads/reads_qc_MAG/MAG_flye_filtlong.fastq
outdir=MAG_cluster

trycycler cluster --assemblies $assemblies/*.fasta --reads $reads --out_dir $outdir --threads $threads

