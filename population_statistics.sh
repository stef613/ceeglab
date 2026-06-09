#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=24:00:00
#$ -N sexpunctata106_reduced
#$ -pe omp 8
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu

module load stacks

species="sexpunctata"
run=106

work=/projectnb/ceeglab/lindens
cd "$work"

output=${work}/stacks/populations/"${species}${run}_reduced"

samples=${work}/stacks/denovo/"${species}${run}"
popmap=${work}/stacks/popmaps/"${species}_reduced_popmap.txt"

mkdir -p "$output"

populations -P "$samples" -t 8 --fstats -O "$output" -M "$popmap" -r 0.2 --min_maf 0.05 --radpainter --vcf --genepop --structure

