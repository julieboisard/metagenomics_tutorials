#!/bin/bash -l
#SBATCH  to define

module load bioinfo-tools Flye/2.9.1

reads=/path/to/porechoped_fastq/*
outdir=/path/to/Flye/co-assembly/

flye --meta --nano-hq $reads --out-dir $outdir --threads 16