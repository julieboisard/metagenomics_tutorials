#!/bin/bash -l

cd MAG_cluster/cluster_001/

reads1=/path/to/reads/reads_qc_MAG/MAG_paired_aligned_fastp.fastq.1.gz
reads2=/path/to/reads/reads_qc_MAG/MAG_paired_aligned_fastp.fastq.2.gz

threads=10
bwa index 8_medaka.fasta
bwa mem -t "$threads" -a 8_medaka.fasta $reads1 > alignments_1.sam
bwa mem -t "$threads" -a 8_medaka.fasta $reads2 > alignments_2.sam