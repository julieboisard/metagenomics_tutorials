#!/bin/bash -l
#SBATCH  to define

module load conda
export CONDA_ENVS_PATH=/path/to/conda/envs
source conda_init.sh
#conda create --name porechop_abi
conda activate porechop_abi
#conda install porechop_abi


for i in /path/to/fastq/*
do
porechop_abi --ab_initio --threads 16 -i $i -o ${i%%.fastq.gz}_porechoped.fastq
done 