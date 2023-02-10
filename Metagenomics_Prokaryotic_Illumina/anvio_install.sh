#!/bin/bash -l
#SBATCH  to define

module load conda

conda activate anvio
conda install -n anvio -y -c bioconda "sqlite>=3.31.1"
conda install -n anvio -y -c bioconda prodigal
conda install -n anvio -y -c bioconda mcl
conda install -n anvio -y -c bioconda muscle=3.8.1551
conda install -n anvio -y -c bioconda hmmer
conda install -n anvio -y -c bioconda diamond
conda install -n anvio -y -c bioconda blast
conda install -n anvio -y -c bioconda megahit
conda install -n anvio -y -c bioconda spades
conda install -n anvio -y -c bioconda bowtie2 tbb=2019.8
conda install -n anvio -y -c bioconda bwa
conda install -n anvio -y -c bioconda samtools=1.9
conda install -n anvio -y -c bioconda centrifuge
conda install -n anvio -y -c bioconda trimal
conda install -n anvio -y -c bioconda iqtree
conda install -n anvio -y -c bioconda trnascan-se
conda install -n anvio -y -c bioconda r-base
conda install -n anvio -y -c bioconda r-stringi
conda install -n anvio -y -c bioconda r-tidyverse
conda install -n anvio -y -c bioconda r-magrittr
conda install -n anvio -y -c bioconda r-optparse
conda install -n anvio -y -c bioconda bioconductor-qvalue
conda install -n anvio -y -c bioconda fasttree
conda install -n anvio -y -c bioconda vmatch
#note: if conda struggles with dependencies conflicts (solving environments for hours), try using [mamba](https://mamba.readthedocs.io/en/latest/) instead
#really quicker

# this last one may cause some issues. if it doesn't install -n anvio,
# don't worry, you will still be fine:
conda install -n anvio -y -c bioconda fastani

#then install anvio
# curl -L https://github.com/merenlab/anvio/releases/download/v7.1/anvio-7.1.tar.gz --output anvio-7.1.tar.gz
# pip install anvio-7.1.tar.gz
# check the install
# anvi-self-test --suite mini
