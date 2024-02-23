#!/bin/bash
#SBATCH  to define

# load the modules you need
ml GCC/10.2.0 SPAdes/3.15.2

# reads
cd /path/to/your/working/dir/

sp=your_species/strain_name

trimmedreads_R1=/path/to/your/trimmed/reads/R1/file
trimmedreads_R2=/path/to/your/trimmed/reads/R1/file
unpaired=/path/to/your/unpairedReads/file

mkdir ${sp}_metaspades

spades.py -t 16 --meta -1 $trimmedreads_R1 -2 $trimmedreads_R2 -s $unpaired -o ${sp}_metaspades

#if job was interrupted for some reasons
#spades.py --continue -o ${sp}_metaspades
