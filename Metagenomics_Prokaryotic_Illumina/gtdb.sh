#!/bin/bash -l
#SBATCH  to define

# load your modules
module load bioinfo-tools
module load GTDB-Tk/1.5.0

cd /your/working/dir

genomedir=/path/to/the/contigs/in/fna/format
outdir=name_of_your_outputdir

gtdbtk classify_wf --genome_dir $genomedir --out_dir $outdir
