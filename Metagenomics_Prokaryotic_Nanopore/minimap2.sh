#!/bin/bash -l
#SBATCH  to define


module load bioinfo-tools minimap2/2.24-r1122 

contigs=/path/to/medaka/consensus/Co-assembly_medaka_consensus/consensus.fasta

minimap2 -t 16 -ax map-ont $contigs /path/to/porechoped_fastq/barcodeXX_porechoped.fastq > Strain1.sam 

minimap2 -t 16 -ax map-ont $contigs /path/to/porechoped_fastq/barcodeYY_porechoped.fastq > Strain2.sam 

minimap2 -t 16 -ax map-ont $contigs /path/to/porechoped_fastq/barcodeZZ_porechoped.fastq > Strain3.sam 

module unload minimap2/2.24-r1122
module load bioinfo-tools samtools/1.17

samtools view -F 4 -bS Strain1.sam > Strain1-RAW.bam
samtools view -F 4 -bS Strain2.sam > Strain2-RAW.bam
samtools view -F 4 -bS Strain3.sam > Strain3-RAW.bam

samtools sort Strain1-RAW.bam > Strain1-RAW-sorted.bam
samtools index Strain1-RAW-sorted.bam

samtools sort Strain2-RAW.bam > Strain2-RAW-sorted.bam
samtools index Strain2-RAW-sorted.bam

samtools sort Strain3-RAW.bam > Strain3-RAW-sorted.bam
samtools index Strain3-RAW-sorted.bam
