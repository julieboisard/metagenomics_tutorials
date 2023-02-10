
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