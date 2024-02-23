#!/bin/bash -l
#SBATCH 

module load bioinfo-tools
module load GTDB-Tk/1.5.0

cd MyBeautifulGenome
genomedir=/path/to/MyBeautifulGenome
outdir=classify_MyBeautifulGenome

gtdbtk classify_wf --extension fasta --genome_dir $genomedir --out_dir $outdir --cpus 100
