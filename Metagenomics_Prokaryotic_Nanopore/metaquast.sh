!/bin/bash

cd ~/SOFTS/quast-master

scaffolds=/path/to/Flye/co_assembly/assembly.fasta
strain=Flye_co_assembly

outdir=/path/to/Flye_co_assembly_metaquast

./metaquast.py $scaffolds --gene-finding --rna-finding --conserved-genes-finding -o $outdir --threads 4