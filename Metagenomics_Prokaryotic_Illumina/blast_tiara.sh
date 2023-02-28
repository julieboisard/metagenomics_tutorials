#!/bin/bash -l
#SBATCH  to define


module load bioinfo-tools blast/2.12.0+

for i in tiara_*/eukarya_contigs.fasta
do
blastn -db nt -query $i -out ${i%%_contigs.fasta}_blast.out -outfmt '6 qseqid sseqid staxids sscinames sskingdoms pident length mismatch gapopen qstart qend sstart send evalue bitscore' -num_threads 16
done
