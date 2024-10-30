#!/bin/bash -l

filtlong --min_length 5000 reads/MAG_nanopore.fastq > reads/reads_qc_MAG/MAG_nanopore_filtlong.fastq
#or
filtlong --keep_percent 90 reads/reads_qc_MAG/MAG_nanopore_filtlong.fastq > reads/reads_qc_MAG/MAG_nanopore_filtlong2.fastq
