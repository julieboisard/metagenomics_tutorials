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

# load the modules
ml GCCcore/10.2.0 MEGAHIT/1.2.9-Python-2.7.18

# reads
runname=megaHIT145_coassembly

cd /your/working/dir

# specify as many independant metagenomes as you want to co assemble
trimmedreads_F1=Strain1_trimR1.fastq
trimmedreads_R1=Strain1_trimR2.fastq
unpaired1=Strain1_unpairedReads.fastq

trimmedreads_F2=Strain2_trimR1.fastq
trimmedreads_R2=Strain2_trimR2.fastq
unpaired2=Strain2_unpairedReads.fastq

trimmedreads_F3=Strain3_trimR1.fastq
trimmedreads_R3=Strain3_trimR2.fastq
unpaired3=Strain3_unpairedReads.fastq

trimmedreads_F4=Strain4_trimR1.fastq
trimmedreads_R4=Strain4_trimR2.fastq
unpaired4=Strain4_unpairedReads.fastq


megahit -1 \
        $trimmedreads_F1,$trimmedreads_F2,$trimmedreads_F3,$trimmedreads_F4 \
        -2 \
        $trimmedreads_R1,$trimmedreads_R2,$trimmedreads_R3,$trimmedreads_R4 \
        -r \
        $unpaired1,$unpaired2,$unpaired3,$unpaired4 \
        -o $runname.dir -t 16
