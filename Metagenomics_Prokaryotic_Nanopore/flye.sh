#!/bin/bash -l
#SBATCH  to define

module load bioinfo-tools Flye/2.9.1

reads=/path/to/porechoped_fastq/barcodeXX_porechoped.fastq
outdir=/path/to/Flye/assembly/

flye --meta --nano-hq $reads --out-dir $outdir --threads 16