
# METAGENOMES_Prokaryotic_SHORT_READS
---

Author: Julie Boisard

!!! Always read software's documentation !!!

The aim of this tutorial is to provide basic guidance on how to analyse prokaryotic short reads metagenomes (Illumina).


## QUALITY CHECK AND TRIMMING

Overall read quality can be checked with [fastqc 0.11.9](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).

Reads trimming can be adressed using [Trimmomatic 0.39](http://www.usadellab.org/cms/?page=trimmomatic) with following arguments:

```
# Example command
java -jar $PATH/trimmomatic-0.39.jar PE \ # phred score, default is phred64
-threads x \ # nb of threads
$rawreadsR1 $rawreadsR2 \
${sp}.P_trimR1.fastq \ #output file for forward paired reads
${sp}.UP_trimR1.fastq \ #output file for forward unpaired reads
${sp}.P_trimR2.fastq \ #output file for reverse paired reads
${sp}.UP_trimR2.fastq \ #output file for reverse unpaired reads
ILLUMINACLIP:/$PATH/Trimmomatic/0.39-Java-11/adapters/TruSeq2-PE.fa:2:30:10 HEADCROP:5 SLIDINGWINDOW:4:20 LEADING:3 TRAILING:3 MINLEN:90
# see manual!
```


## METASPADES ASSEMBLY

All strains/samples must be assembled independly using Spades 3.15.2 with following options:
`spades.py -t 16 --meta -1 $trimmedreads_R1 -2 $trimmedreads_R2 -s $unpaired -o ${sp}_metaspades`

Template script:
`metaspades_assembly.sh `

## MEGAHIT CO-ASSEMBLY

A co-assembly can be performed using megahit to allow differential coverage analysis between samples.

Associated scripts:
`megahit145_co_assembly.sh `


## ASSEMBLY QUALITY CHECK AND PRELIMINARY ANALYSIS

Metaquast runs fast, can be run on a laptop.

All assemblies should be checked with metaquast 5.2 using following arguments:
`metaquast.py $scaffolds --gene-finding --rna-finding --conserved-genes-finding -o $outdir`

Template script:
`metaquast.sh`

## MAPPING

All reads librairies should be mapped to the co-assembly using bowtie2 and samtools.

They will be used to compute the differential coverage by anvio during the binning process.

Output are BAM and SAM files.

WARNING: before mapping on the megaHIT co-assembly, delete all spaces in the final.contigs.fa header
`sed 's/ /_/g' final.contigs.fa > final.contigs.sed.fa`
Otherwise ANVIO will not accept the bam files.

Template script:
`mapping_megahit.sh`

## METAGENOMIC BINNING WITH anvio

ANVIO [tutorial](https://merenlab.org/2016/06/22/anvio-tutorial-v2/)

Install anvio template script:
`anvio_install.sh`

Run anvio template script:
`anvio_megahit.sh`

Visualize anvio analysis (on local laptop)
`anvi-interactive -p SAMPLES-MERGED/PROFILE.db -c contigs.db`

Visualize anvio analysis ([on a server through a tunnel](https://merenlab.org/2015/11/28/visualizing-from-a-server/))

[Binning on anvio with anvi-interactive](https://anvio.org/help/7/programs/anvi-interactive/) (Bins tab, make as many bins as you want using taxonomy information, completion and redundancy. **Please read documentation**).

You can save your collection of bins (-C) and when you're done, generate a summary of your binning.
`anvi-summarize -p SAMPLES-MERGED/PROFILE.db -c final.contigs.sed.db -C megahit -o MERGED_SUMMARY`


[Refine a bin using anvi-refine](https://merenlab.org/2015/05/11/anvi-refine/): when you have bins of interest, you may want to take a closer look at them, refining them one by one - ie contig by contig.
`anvi-refine -p SAMPLES-MERGED/PROFILE.db -c final.contigs.sed.db -C megahit -b Malaciobacter_marinus`

After binning and summarizing, you can compute relative abundance of all MAGs.
`anvi-estimate-scg-taxonomy -c final.contigs.sed.db -p ./SAMPLES-MERGED/PROFILE.db --metagenome-mode --compute-scg-coverages --output-file final.contigs.sed.db-abundance.txt`

**Don't forget to run a new summary after refining is done.**
`anvi-summarize -p SAMPLES-MERGED/PROFILE.db -c final.contigs.sed.db -C megahit -o MERGED_SUMMARY`

## ANNOTATION WITH PROKKA

MAGs of interests can get gene prediction and basic annotation using PROKKA.

```
conda install -c conda-forge -c bioconda -c defaults prokka
prokka --compliant my_favorite_bins_contigs.fasta
```

## ANNOTATION WITH KEGG

Download and install [KofamScan](https://github.com/takaram/kofam_scan) in order to get metabolic pathways annotation.

KofamScan will output a mapper file (--mapper) that can be uploaded on [Kegg](https://www.kegg.jp/kegg/mapper/reconstruct.html)


## TAXONOMIC INVESTIGATION WITH GTDB

See [Manual](https://ecogenomics.github.io/GTDBTk/examples/classify_wf.html)

Be careful, the hardware requierments are huge with GTDB.

Template script:
`gtdb.sh`

Basically the whole taxonomical assignation workflow can be run using this command:
`gtdbtk classify_wf --genome_dir <my_genomes> --out_dir <output_dir>`

## LOOKING FOR EUKARYOTIC SEQUENCES WITH TIARA

[TIARA](https://github.com/ibe-uw/tiara) is a deep-learning-based approach for identification of eukaryotic sequences in the metagenomic data powered by PyTorch.

The sequences are classified in two stages:
* In the first stage, the sequences are classified to classes: archaea, bacteria, prokarya, eukarya, organelle and unknown.
* In the second stage, the sequences labeled as organelle in the first stage are classified to either mitochondria, plastid or unknown.


```
# install tiara
conda create --name tiara-env python=3.8
conda activate tiara-env
mamba install -c conda-forge tiara
conda install -c conda-forge mamba
mamba install -c conda-forge tiara
tiara-test

# run tiara on a metagenome
tiara -i contigs.fasta -o tiara_strain1.txt --tf all -t 4 --probabilities
```
We can then blast the "eukarya" contigs (see `blast_tiara.sh`) and then sort the output

```
cat eukarya_blast_strain1.out | sort -t "	" -k1,1 -k15,15nr > eukarya_blast_strain1_sorted.out
cat eukarya_blast_strain1_sorted.out | sort -k1,1 -u > eukarya_blast_strain1_sorted_BH.out

```
## LOOKING FOR EUKARYOTIC SEQUENCES WITH WHOKARYOTE

[Whokaryote](https://github.com/LottePronk/whokaryote) is a tool designed to distinguish eukaryotic and prokaryotic contigs in metagenomes based on gene structure. It also uses Tiara as an option.

```
conda create -c bioconda -n whokaryote whokaryote                               
conda activate whokaryote

# run whokaryote
whokaryote.py --contigs contigs.fasta --outdir whokaryote_output --f --minsize 1000

```

We can then blast the "eukaryotes" contigs as we did with tiara blast outputs.
