#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=24:00:00
#$ -N combined
#$ -pe omp 8
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu

module load stacks

species="combined"
run=1

work=/projectnb/ceeglab/lindens
cd "$work"

output=${work}/stacks/populations/"${species}${run}"

samples=${work}/stacks/denovo/100k/"${species}${run}"
popmap=${work}/stacks/popmaps/"${species}_popmap.txt"

mkdir -p "$output"

populations -P "$samples" -t 8 -O "$output" -M "$popmap" -r 0.2 --min_maf 0.05 --vcf --genepop --structure --radpainter --fstats

