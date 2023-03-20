
# METAGENOMES_Prokaryotic_LONG_READS
---

Author: Julie Boisard

!!! Always read software's documentation !!!

The aim of this tutorial is to provide basic guidance on how to analyse prokaryotic long reads metagenomes (Nanopore).


## RAW DATA

The data consists of raw squiggle data in FAST5 format and basecalled sequence reads in FASTQ format, using the `Phred33/Sanger/Illumina 1.8+` encoding.

Nanopore output consists in a lot of fastq for a given barcode. You may find useful to concatenate all fastq per barcode/sample.

```
cat ./barcodeXX/* > barcodeXX.fastq.gz
cat ./barcodeYY/* > barcodeYY.fastq.gz
cat ./barcodeZZ/* > barcodeZZ.fastq.gz

```

## ADAPTATORS TRIMMING

### porechop-abi

Adaptators can be trimmed using Porechop_ABI 0.5.0.

[Porechop_ABI](https://github.com/bonsai-team/Porechop_ABI) (ab initio) is an extension of Porechop whose purpose is to process adapter sequences in ONT reads.

The difference with the initial version of Porechop is that Porechop_ABI does not use any external knowledge or database for the adapters. Adapters are discovered directly from the reads using approximate k-mers counting and assembly. Then these sequences can be used for trimming, using all standard Porechop options.

```
poreshop.sh

```


## ASSEMBLY

### Flye

Each sample must be assembled independantly then all samples co-assembled using [Flye 2.9.1](https://github.com/fenderglass/Flye).

Flye is a de novo assembler for single-molecule sequencing reads, such as those produced by PacBio and Oxford Nanopore Technologies. It is designed for a wide range of datasets, from small bacterial projects to large mammalian-scale assemblies. The package represents a complete pipeline: it takes raw PacBio / ONT reads as input and outputs polished contigs. Flye also has a special mode for metagenome assembly.


```
flye.sh
flye_co.sh
```

### Polishing assemblies with medaka

[medaka](https://github.com/nanoporetech/medaka) is a tool to create consensus sequences and variant calls from nanopore sequencing data. This task is performed using neural networks applied a pileup of individual sequencing reads against a draft assembly. It provides state-of-the-art results outperforming sequence-graph based methods and signal-based methods, whilst also being faster.

Be careful to choose the apropriate model (-m). List of models available with `medaka tools list\_models`.

`medaka.sh`

Polish all assemblies and co-assemblies with medaka.


### QC

Quality was checked using metaquast 5.2 on all assemblies.


### Mapping with minimap2 and samtools

Reads can be mapped back on the polished co-assembled metagenome and sorted using [minimap2 2.24-r1122](https://github.com/lh3/minimap2) and samtools 1.17.

`minimap2.sh`


### Binning with Anvi'o


ANVIO [tutorial](https://merenlab.org/2016/06/22/anvio-tutorial-v2/)


Install anvio
`anvio_install_uppmax.sh`

Run anvio
`anvio_flye.sh`

Visualize anvio analysis (on local laptop)
`anvi-interactive -p SAMPLES-MERGED/PROFILE.db -c contigs.db`

Visualize anvio analysis ([on a server through a tunnel](https://merenlab.org/2015/11/28/visualizing-from-a-server/))

[Binning on anvio with anvi-interactive](https://anvio.org/help/7/programs/anvi-interactive/) (Bins tab, make as many bins as you want using taxonomy information, completion and redundancy. Please read documentation).

You can save your collection of bins (-C) and when you're done, generate a summary of your binning.
`anvi-summarize -p SAMPLES-MERGED/PROFILE.db -c consensus.fasta.db -C flyebin -o FLYE_MERGED_SUMMARY`


[Refine a bin using anvi-refine](https://merenlab.org/2015/05/11/anvi-refine/): when you have bins of interest, you may want to take a closer look at them, refining them one by one - ie contig by contig.
`anvi-refine -p SAMPLES-MERGED/PROFILE.db -c consensus.fasta.db -C flyebin -b your_bin`

**Don't forget to run a new summary after refining is done.**
`anvi-summarize -p SAMPLES-MERGED/PROFILE.db -c consensus.fasta.db -C flyebin -o FLYE_MERGED_SUMMARY`

After binning and summarizing, you can compute relative abundance of all MAGs.
`anvi-estimate-scg-taxonomy -c consensus.fasta.db -p ./SAMPLES-MERGED/PROFILE.db --metagenome-mode --compute-scg-coverages --output-file consensus.fasta.db-abundance.txt`

We can then recalculate the taxonomical profile on the bins.
`anvi-estimate-scg-taxonomy -c consensus.fasta.db -p ./SAMPLES-MERGED/PROFILE.db -C flyebin --output-file consensus.fasta.db-taxonomy-bins.txt `