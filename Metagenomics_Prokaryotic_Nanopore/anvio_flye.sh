#!/bin/bash -l
#SBATCH  to define

module load conda
export CONDA_ENVS_PATH=/path/to/conda/envs/
source conda_init.sh
conda activate anvio

cd /anvio_folder/

anvi-gen-contigs-database -f consensus.fasta -o consensus.fasta.db -n Flye
anvi-run-hmms -c consensus.fasta.db --num-threads 16
anvi-display-contigs-stats consensus.fasta.db --report-as-text -o consensus.fasta.db-contigs-stats.txt
anvi-run-ncbi-cogs -c consensus.fasta.db --num-threads 16
anvi-run-scg-taxonomy -c consensus.fasta.db
anvi-estimate-scg-taxonomy -c consensus.fasta.db --metagenome-mode --output-file consensus.fasta.db-taxonomy.txt --num-threads 16

anvi-profile -i /path/to/bamfiles/Strain1-RAW-sorted.bam -c consensus.fasta.db --min-contig-length 1000 --output-dir Strain_01 --sample-name Strain_01 --num-threads 16
anvi-profile -i /path/to/bamfiles/Strain2-RAW-sorted.bam -c consensus.fasta.db --min-contig-length 1000 --output-dir Strain_02 --sample-name Strain_02 --num-threads 16
anvi-profile -i /path/to/bamfiles/Strain3-RAW-sorted.bam -c consensus.fasta.db --min-contig-length 1000 --output-dir Strain_03 --sample-name Strain_03 --num-threads 16

anvi-merge */PROFILE.db -o SAMPLES-MERGED -c consensus.fasta.db --enforce-hierarchical-clustering
