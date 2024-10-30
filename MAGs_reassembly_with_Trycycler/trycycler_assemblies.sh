#!/bin/bash -l

threads=30 # change as appropriate for your system
mkdir MAG_assemblies
reads=read_subsets_MAG
outdir=MAG_assemblies

flye --nano-hq $reads/sample_01.fastq --threads "$threads" --out-dir assembly_01 && cp assembly_01/assembly.fasta $outdir/assembly_01.fasta && rm -r assembly_01
sh miniasm_and_minipolish.sh $reads/sample_02.fastq "$threads" > assembly_02.gfa && any2fasta assembly_02.gfa > $outdir/assembly_02.fasta && rm assembly_02.gfa
raven --threads "$threads" --disable-checkpoints $reads/sample_03.fastq > $outdir/assembly_03.fasta

flye --nano-hq $reads/sample_04.fastq --threads "$threads" --out-dir assembly_04 && cp assembly_04/assembly.fasta $outdir/assembly_04.fasta && rm -r assembly_04
sh miniasm_and_minipolish.sh $reads/sample_05.fastq "$threads" > assembly_05.gfa && any2fasta assembly_05.gfa > $outdir/assembly_05.fasta && rm assembly_05.gfa
raven --threads "$threads" --disable-checkpoints $reads/sample_06.fastq > $outdir/assembly_06.fasta

flye --nano-hq $reads/sample_07.fastq --threads "$threads" --out-dir assembly_07 && cp assembly_07/assembly.fasta $outdir/assembly_07.fasta && rm -r assembly_07
sh miniasm_and_minipolish.sh $reads/sample_08.fastq "$threads" > assembly_08.gfa && any2fasta assembly_08.gfa > $outdir/assembly_08.fasta && rm assembly_08.gfa
raven --threads "$threads" --disable-checkpoints $reads/sample_09.fastq > $outdir/assembly_09.fasta

flye --nano-hq $reads/sample_10.fastq --threads "$threads" --out-dir assembly_10 && cp assembly_10/assembly.fasta $outdir/assembly_10.fasta && rm -r assembly_10
sh miniasm_and_minipolish.sh $reads/sample_11.fastq "$threads" > assembly_11.gfa && any2fasta assembly_11.gfa > $outdir/assembly_11.fasta && rm assembly_11.gfa
raven --threads "$threads" --disable-checkpoints $reads/sample_12.fastq > $outdir/assembly_12.fasta
