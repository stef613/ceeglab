#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=12:00:00
#$ -N rename_files
#$ -pe omp 8G
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu

work=/projectnb/ceeglab/lindens/Csex_Dgut_RAD_2025-2026/fq_clean

for f in "${work}"/*_cleaned.r1.fq.gz; do
    mv "$f" "${f/.r1./.1.}"
done

for f in "${work}"/*_cleaned.r2.fq.gz; do
    mv "$f" "${f/.r2./.2.}"
done
