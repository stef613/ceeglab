#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=15:00:00
#$ -N process_radtags_guttata_6
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu
#$ -pe omp 8

module load stacks 
#module load gzip

OUT=/projectnb/ceeglab/lindens/stacks/denovo/02_process_radtags_guttata
META=/projectnb/ceeglab/lindens/meta
RAW=/projectnb/ceeglab/lindens/raw_fastq

#mkdir -p "$OUT"

#may need to edit: INPUT directory (CHECK if names are in standard Illumina format - if not, will need to specify files), barcodes file name
process_radtags \
    -p "$RAW" \
    -o "$OUT" \
    -b "$META/barcodes_guttata_raw.txt" \
    -P \
    -i gzfastq \
    --renz_1 ecoRI \
    --renz_2 sbfI \
    -r \
    -c \
    -q \
    --retain_header \
    --filter_illumina \
    --disable_rad_check

#this is the first step of the STACKS pipeline. process_radtags demultiplexes the data and discards low quality reads.
