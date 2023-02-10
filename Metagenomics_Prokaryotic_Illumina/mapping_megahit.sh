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


## load your modules

ml GCC/10.2.0 Bowtie2/2.4.2

## Variables to set

contigs=/path/to/your/contigs

# specify the paths to the reads for each sample/strain
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

## BUILD INDEX OF METAGENOME ASSEMBLY

cd /path/to/your/working/dir

bowtie2-build --threads 16 $contigs bamfiles/contigs


## MAP EACH 'Sample' to the contigs

bowtie2 --threads 16 -x bamfiles/contigs \
-1 $trimmedreads_F1 \
-2 $trimmedreads_R1 \
-U $unpaired1 \
-S bamfiles/Strain1.sam

bowtie2 --threads 16 -x bamfiles/contigs \
-1 $trimmedreads_F2 \
-2 $trimmedreads_R2 \
-U $unpaired2 \
-S bamfiles/Strain2.sam

bowtie2 --threads 16 -x bamfiles/contigs \
-1 $trimmedreads_F3 \
-2 $trimmedreads_R3 \
-U $unpaired3 \
-S bamfiles/Strain3.sam

bowtie2 --threads 16 -x bamfiles/contigs \
-1 $trimmedreads_F4 \
-2 $trimmedreads_R4 \
-U $unpaired4 \
-S bamfiles/Strain4.sam

module unload GCC/10.2.0 Bowtie2/2.4.2
module load  GCC/11.2.0 SAMtools/1.14


## Convert SAM TO BAM for ANVIO

samtools view -F 4 -bS bamfiles/Strain_01.sam > bamfiles/Strain1-RAW.bam
samtools view -F 4 -bS bamfiles/Strain_04.sam > bamfiles/Strain2-RAW.bam
samtools view -F 4 -bS bamfiles/Strain_05.sam > bamfiles/Strain3-RAW.bam
samtools view -F 4 -bS bamfiles/Strain_02.sam > bamfiles/Strain4-RAW.bam


## Sort bam and INDEX

samtools sort bamfiles/Strain1-RAW.bam > bamfiles/Strain1-RAW-sorted.bam
samtools index bamfiles/Strain1-RAW-sorted.bam

samtools sort bamfiles/Strain2-RAW.bam > bamfiles/Strain2-RAW-sorted.bam
samtools index bamfiles/Strain2-RAW-sorted.bam

samtools sort bamfiles/Strain3-RAW.bam > bamfiles/Strain_3-RAW-sorted.bam
samtools index bamfiles/Strain3-RAW-sorted.bam

samtools sort bamfiles/Strain4-RAW.bam > bamfiles/Strain4-RAW-sorted.bam
samtools index bamfiles/Strain4-RAW-sorted.bam
