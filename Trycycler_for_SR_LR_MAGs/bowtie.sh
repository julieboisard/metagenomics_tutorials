#!/bin/bash -l
#SBATCH 

ml bioinfo-tools bowtie2/2.4.5 # check

## Variables to set
trimmedreads_F1=/path/to/trimmR1.fastq
trimmedreads_R1=/path/to/trimR2.fastq
unpaired1=/path/to/unpairedReads.fastq

## build an index for MAG
bowtie2-build --threads 16 /path/to/MAGs-contigs.fa /path/to/bamfiles/MAG

## MAP SR reads to MAG and get mapped reads in fastq
bowtie2 --threads 16 -x /path/to/bamfiles/MAG \
-1 $trimmedreads_F1 \
-2 $trimmedreads_R1 \
-U $unpaired1 \
--al-conc-gz /path/to/bamfiles/MAG/MAG_paired_aligned.fastq.gz \
--al-gz /path/to/bamfiles/MAG/MAG_unpaired_aligned.fastq.gz \
-S /path/to/bamfiles/MAG/MAG.sam

