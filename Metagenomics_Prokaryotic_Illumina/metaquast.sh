!/bin/bash
# run locally it's quick

cd ~/SOFTS/quast-master

scaffolds=/path/to/your/contigs
outdir=name_of_your_output_dir

metaquast.py $scaffolds --gene-finding --rna-finding --conserved-genes-finding -o $outdir
