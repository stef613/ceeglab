#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=96:00:00
#$ -N guttata
#$ -t 300-335
#$ -pe omp 28
#$ -l mem_per_core=9G
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu

module load stacks

work=/projectnb/ceeglab/lindens
samples="${work}"/Csex_Dgut_RAD_2025-2026/fq_clean

#create output label
species="guttata"
job="${species}${SGE_TASK_ID}"

parameterFile="${species}_denovo_parameters.csv" #this file has four columns: job number, M value, m value, n value

#get parameter values from the csv file
parameterValues="${work}"/stacks/denovo/"$parameterFile"
read M m n < <(awk -F',' -v t="$SGE_TASK_ID" 'NR>1 && $1==t {print $2, $3, $4}' "$parameterValues")

#get popmap
popmap="${species}_100k_popmap.txt"

popmap="${work}"/stacks/popmaps/"$popmap"
output="${work}"/stacks/denovo/100k/"$job"

cd "$work"
mkdir -p "$output"

# main stacks command

denovo_map.pl \
        --samples "$samples" \
        --popmap "$popmap" \
        -o "$output" \
	-m "$m" \
        -M "$M" \
        -n "$n" \
	--paired \
        -T 28
