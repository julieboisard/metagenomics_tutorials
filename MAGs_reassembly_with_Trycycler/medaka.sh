#!/bin/bash -l

outdir=MAG_cluster

medaka_consensus -i $outdir/cluster_001/4_reads.fastq -d $outdir/cluster_001/7_final_consensus.fasta -o $outdir/cluster_001/medaka -m r941_prom_hac_g507
mv $outdir/cluster_001/medaka/consensus.fasta $outdir/cluster_001/8_medaka.fasta
rm -r $outdir/cluster_001/medaka $outdir/cluster_001/*.fai $outdir/cluster_001/*.mmi