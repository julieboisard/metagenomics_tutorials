#!/bin/bash -l
#SBATCH  to define

module load conda
export CONDA_ENVS_PATH=/path/to/conda/envs
source conda_init.sh
#conda create -n medaka -c conda-forge -c bioconda medaka
conda activate medaka


BASECALLS=/path/to/porechoped_fastq/barcodeXX_porechoped.fastq
DRAFT=/path/to/Flye/assembly/assembly.fasta
OUTDIR=/path/to/medaka/consensus/Strain1_medaka_consensus

medaka_consensus -i ${BASECALLS} -d ${DRAFT} -o ${OUTDIR} -t 16 -m r941_prom_hac_g507