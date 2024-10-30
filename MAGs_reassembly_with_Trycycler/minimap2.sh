#!/bin/bash -l
#SBATCH 

cd bamfiles/

module load bioinfo-tools minimap2/2.24-r1122 

## Variables to set
reads=/path/to/porechoped_fastq/barcodeXX_porechoped.fastq

## MAP LR reads to MAG
minimap2 -t 16 -ax map-ont --sam-hit-only /path/to/MAGs-contigs.fa $reads > MAG_nanopore.sam 

# Index and get mapped reads in fastq
module load bioinfo-tools samtools/1.17
samtools view -F 4 -bS MAG_nanopore.sam > MAG_nanopore_mapped.bam
samtools sort MAG_nanopore_mapped.bam > MAG_nanopore_mapped_sorted.bam
samtools index MAG_nanopore_mapped_sorted.bam
samtools fastq MAG_nanopore_mapped_sorted.bam  > MAG_nanopore.fastq
