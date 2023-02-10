#!/bin/bash -l
#SBATCH  to define

# load your modules
module load conda
conda activate anvio

cd /your/mapping/folder

anvi-gen-contigs-database -f contigs.fa -o contigs.db -n megaHIT
anvi-run-hmms -c contigs.db --num-threads 8
anvi-display-contigs-stats contigs.db --report-as-text -o contigs.db-contigs-stats.txt
anvi-run-ncbi-cogs -c contigs.db --num-threads 8
anvi-run-scg-taxonomy -c contigs.db
anvi-estimate-scg-taxonomy -c contigs.db --metagenome-mode --output-file contigs.db-taxonomy.txt --num-threads 8

# run anvio on each of your metagenomes using previously generated bamfiles
anvi-profile -i ./bamfiles/Strain_01-RAW-sorted.bam -c contigs.db --min-contig-length 1000 --output-dir Strain_01 --sample-name Strain_01 --num-threads 8
anvi-profile -i ./bamfiles/Strain_02-RAW-sorted.bam -c contigs.db --min-contig-length 1000 --output-dir Strain_02 --sample-name Strain_02 --num-threads 8
anvi-profile -i ./bamfiles/Strain_04-RAW-sorted.bam -c contigs.db --min-contig-length 1000 --output-dir Strain_04 --sample-name Strain_04 --num-threads 8
anvi-profile -i ./bamfiles/Strain_05-RAW-sorted.bam -c contigs.db --min-contig-length 1000 --output-dir Strain_05 --sample-name Strain_05 --num-threads 8

# merge all the metagenomes
anvi-merge */PROFILE.db -o SAMPLES-MERGED -c contigs.db --enforce-hierarchical-clustering
