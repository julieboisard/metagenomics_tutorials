# TRYCYCLER ASSEMBLY WITH SHORT AND LONG READS FROM MAGS

Author: Julie Boisard

!!! Always read software's documentation !!!

The aim of this project is to provide guidance on how to perform the best MAG using both long read assembly and long read / short read polishing.

We will mostly follow the method provided by [Assembling the perfect bacterial genome using Oxford Nanopore and Illumina sequencing. Ryan R. Wick, Louise M. Judd, Kathryn E. Holt](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010905).

MAG: Metagenome-assembled Genome

## MAPPING of SR/LR ON MAGS

Given a prokaryotic MAG (long reads).

For further analysis, we need:

* mapped short reads from illumina SR metagenome to MAG of interest in a fastq.gz format
* mapped long reads from LR nanopore metagenome to MAG of interest in a fastq.gz format

See associated scripts

`bowtie.sh`
`minimap2.sh`

Bowtie2 can output directly the mapped reads in fastq.gz, but minimap2 does not. We'll use `samtools` to extract the fastq from the sam files.

`samtools fastq INPUT.bam > OUTPUT.fastq`



## ASSEMBLY PIPELINE ENVIRONMENT

We will follow the protocol proposed in [Assembling the perfect bacterial genome using Oxford Nanopore and Illumina sequencing. Ryan R. Wick, Louise M. Judd, Kathryn E. Holt](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010905).

An environment can been created with mamba/conda using the config file from this [tutorial](https://github.com/rrwick/Perfect-bacterial-genome-tutorial/wiki/Requirements#conda-environment)

`mamba env create --file environment.yml --name trycycler_mag`


We will now follow this [tutorial](https://github.com/rrwick/Perfect-bacterial-genome-tutorial/wiki/Tutorial-%28easy%29) step by step.
Please refer to the original paper and tutorial to get more information, especially the detailed workflow and output files generated.
Here are the main steps summarized and specific informations for our situation.

## READS QC

The goal of read QC is to discard low-quality reads and/or trim off low-quality regions of reads.

For Illumina reads:
`fastp.sh`

Ater checking the unpaired files are (nearly) empty, we can discard them.
`rm *.u*.gz`

For Nanopore reads:
`filtlong.sh`


## TRYCYCLER 

[Trycycler](https://github.com/rrwick/Trycycler/wiki) is a tool that takes as input multiple separate long-read assemblies of the same genome (e.g. from different assemblers or different read subsets) and produces a consensus long-read assembly.


### step 1: subsampling reads

`trycycler subsample --reads reads/reads_qc_MAG/MAG_nanopore_filtlong.fastq --out_dir read_subsets_MAG --genome_size 3m`

### step 2: make assemblies 

`trycycler_asssemblies.sh`

WARNING: you'll also need the script `miniasm_and_minipolish.sh` available [here](https://github.com/rrwick/Minipolish/blob/main/miniasm_and_minipolish.sh) - don't forget to `chmod 777`it 

as well as to install [any2fasta](https://github.com/tseemann/any2fasta) using 

`mamba install -c bioconda any2fasta`


### step 3: cluster contigs from different assemblies

`trycycler_cluster.sh`

/!\ Manual inspection needed /!\

> You'll now need to decide which clusters represent genuine replicons (and should be kept) and which are erroneous (and should be discarded). 

> This is a key point of human judgement in the Trycycler pipeline. 

See [tutorial](https://github.com/rrwick/Perfect-bacterial-genome-tutorial/wiki/Tutorial-%28easy%29) for more information.

We have lots of clusters most of the times, due to metagenomic data. The cluster of interest should be the cluster_001. The total length and coverage should be consistent between assemblies.

Example:
```
MAG_cluster/cluster_001/1_contigs:
  MAG_cluster/cluster_001/1_contigs/A_contig_10.fasta:  2,573,000 bp,  63.4x
  MAG_cluster/cluster_001/1_contigs/B_utg000001l.fasta: 2,605,115 bp,  63.0x
  MAG_cluster/cluster_001/1_contigs/D_contig_29.fasta:  2,572,609 bp,  63.4x
  MAG_cluster/cluster_001/1_contigs/F_Utg1966.fasta:    2,138,195 bp,  67.4x
  MAG_cluster/cluster_001/1_contigs/G_contig_28.fasta:  2,572,669 bp,  63.4x
  MAG_cluster/cluster_001/1_contigs/H_utg000001l.fasta: 2,591,103 bp,  63.3x
  MAG_cluster/cluster_001/1_contigs/J_contig_23.fasta:  2,572,800 bp,  63.4x
```


### step 4: reconcile 

/!\ Human judgement and inspection needed /!\

> This step usually requires human judgement and interaction. 

> Some contigs may not circularise and will need to be repaired or discarded. 

> This is the hardest part of Trycycler assembly – it gets easier after this!

See [tutorial](https://github.com/rrwick/Perfect-bacterial-genome-tutorial/wiki/Tutorial-%28easy%29) for more information.

`trycycler reconcile --reads $reads  --cluster_dir $outdir/cluster_001`

when an error occurs - ie a contig can't be circularized for instance, you will have to discard the "bad" contig

`Error: failed to circularise sequence K_utg000001l because it contained too large of a start-end gap. You can either increase the value of the --max_add_seq/--max_add_seq_percent parameters or exclude the sequence altogether and try again.`

`Error: some pairwise worst-1kbp identities are below the minimum allowed value of 25.0%. Please remove offending sequences or lower the --min_1kbp_identity threshold and try again.`

`mv MAG_cluster/cluster_001/1_contigs/A_xxxx.fasta MAG_cluster/cluster_001/1_contigs/A_xxxx.fasta.bad`

And try reconciling again, until no errors is found. 


### step 5: alignment

Now you can run msa on your cluster(s) of interest to generate a multiple sequence alignment.

`trycycler msa --cluster_dir $outdir/cluster_001`


### step 6: read partitioning

This step is to assign each read to a cluster. Each of your clusters of interest should now have a 4_reads.fastq file that contains the reads associated with the cluster. 

These will be used in the next Trycycler step (consensus) and during Medaka polishing.

`trycycler partition --reads $reads --cluster_dirs $outdir/cluster_001`


### step 7: consensus generation

The final Trycycler step is to run trycycler consensus to generate a consensus sequence for each cluster (or your cluster of interest here, the Arcobacter cluster)

`trycycler consensus --cluster_dir $outdir/cluster_001`


## MEDAKA

[Medaka](https://github.com/nanoporetech/medaka) polishing aims to fix as many remaining errors in your assembly using only ONT reads. The goal is to produce the best possible ONT-only assembly.

Medaka is pretty easy to run – the only key thing is matching its model to your pore/speed/basecaller. 

For this nanopore data, the `r941_prom_hac_g507` model is the best match. 

`sh medaka.sh > MAG_medaka.txt 2>&1`


## POLYPOLISH

At this point your Trycycler+Medaka assembly is the best possible genome you can get using only ONT reads. 

If all went well, it should only contain small-scale errors (mostly single-bp substitutions and indels). 

The goal of short-read polishing is to fix these small-scale errors using Illumina reads.

Polypolish is a very safe polisher, i.e. it's unlikely to introduce any errors during polishing, so you should use it first.

First, align your Illumina reads (separately for the _1 and _2 files) to your assembly using the all-alignments-per-read option.

`sh bwa.sh > MAG_bwa.txt 2>&1`

Then run Polypolish's insert size filter to exclude alignments with incongruous insert sizes, and finally run Polypolish with the filtered alignments.

`sh polypolish.sh > MAG_polypolish.txt 2>&1`

**Now you have your best possibly assembled MAGs from multiple long reads assemblies and corrected by both long and short reads.**

`MAG_trycycler_medaka_polypolish.fasta`


## Compare the assemblies

This is a script to compare medaka polished assembly with polypolished assembly.

`compare_assemblies.py 8_medaka.fasta MAG_trycycler_medaka_polypolish.fasta`

From the [tutorial](https://github.com/rrwick/Perfect-bacterial-genome-tutorial/wiki/Tutorial-%28easy%29)

> The expectation is that Polypolish's changes are small (mostly single-bp) and sparsely distributed across the genome. 

> If you see large changes or clusters of changes, that's a red flag that something odd could be happening at that part of the genome.



## What if my long reads set are not enough (depth <25x) 

In this case, especially as we have short reads, we can try Unicycler. 



## TAXONOMIC ASSIGNATION WITH GTDB

`gtdb.sh`

Be careful with this one, it requieres a **lot** of RAM. Ask for a node and add the `-C mem256GB` if you need more than 148GB of RAM. 

If you want to convert the big gtdb tree in an itol friendly file, use 

`gtdbtk convert_to_itol --input_tree gtdbtk.bac120.classify.tree --output_tree gtdbtk.bac120.classify.itol.tree`

However this is only available in version 2 of gtdb.
You can installed the newest version locally just to convert the file if your hpc is not up-to-date.


## ANNOTATION WITH PROKKA

[Prokka](https://github.com/tseemann/prokka) runs very quickly on a regular laptop / install with conda.

```bash
for i in *.fasta
do
prokka --compliant $i --prefix ${i%%.fasta}_PROKKA
done
```

## Vizualise with Genovi

`genovi -i MAG_trycycler_medaka_polypolish.gbk -s complete -cs paradise --title "My beautiful genome" `
