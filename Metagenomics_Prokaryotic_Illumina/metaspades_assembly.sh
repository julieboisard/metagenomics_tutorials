#!/bin/bash
#SBATCH  to define

#SBATCH -c 16
# Tasks per node #SBATCH --task-per-node=20
# here you will be charge for 80 cores so be careful what you ask
# Set OMP_NUM_THREADS to the same value as -c
# with a fallback in case it isn't set.
# SLURM_CPUS_PER_TASK is set to the value of -c, but only if -c is explicitly set
if [ -n "$SLURM_CPUS_PER_TASK" ]; then
  omp_threads=$SLURM_CPUS_PER_TASK
else
  omp_threads=16
fi
export OMP_NUM_THREADS=$omp_threads

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
