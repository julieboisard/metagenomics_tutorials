#!/bin/bash -l

fastp --in1 reads/MAG_paired_aligned.fastq.1.gz --in2 reads/MAG_paired_aligned.fastq.2.gz \
--out1 reads/reads_qc_MAG/MAG_paired_aligned_fastp.fastq.1.gz \
--out2 reads/reads_qc_MAG/MAG_paired_aligned_fastp.fastq.2.gz \
--unpaired1 reads/reads_qc_MAG/MAG_unpaired_aligned_fastp.fastq.u1.gz \
--unpaired2 reads/reads_qc_MAG/MAG_unpaired_aligned_fastp.fastq.u2.gz

