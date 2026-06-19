#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=15:00:00
#$ -N process_radtags_guttata_single_3
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu
#$ -pe omp 8

OUT=/projectnb/ceeglab/lindens/stacks/denovo/03_process_radtags_guttata
META=/projectnb/ceeglab/lindens/meta
RAW=/projectnb/ceeglab/lindens/raw_fastq

#mkdir -p "$OUT"

#may need to edit: INPUT directory (CHECK if names are in standard Illumina format - if not, will need to specify files), barcodes file name

process_radtags \
    -o "$OUT" \
    -b "$META/barcodes_guttata_raw.txt" \
    -1 /projectnb/ceeglab/lindens/raw_fastq/guttata-p11-502_R1.fq.gz \
    -2 /projectnb/ceeglab/lindens/raw_fastq/guttata-p11-502_R2.fq.gz \
    -i gzfastq \
    --renz_1 ecoRI \
    --renz_2 sbfI \
    -r \
    -c \
    -q
