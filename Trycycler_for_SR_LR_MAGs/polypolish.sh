#!/bin/bash -l
cd MAG_cluster/cluster_001/

polypolish_insert_filter.py --in1 alignments_1.sam --in2 alignments_2.sam --out1 filtered_1.sam --out2 filtered_2.sam

polypolish 8_medaka.fasta filtered_1.sam filtered_2.sam > MAG_trycycler_medaka_polypolish.fasta
rm *.bwt *.pac *.ann *.amb *.sa *.sam