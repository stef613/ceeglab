#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=96:00:00
#$ -N structure
#$ -t 7-475
#$ -pe omp 16
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu

STRUCTURE=/projectnb/ceeglab/lindens/software/structure/2.3.4/console/structure

work=/projectnb/ceeglab/lindens

parameterFile=${work}/structure/"structure_run_info.csv"

#get parameter values from the csv file
read species file replicate MAXPOPS NUMLOCI NUMINDS < <(awk -F',' -v t="$SGE_TASK_ID" 'NR>1 && $1==t {print $2, $3, $4, $5, $6, $7}' "$parameterFile")

mainParams=${work}/structure/"mainparams_${species}.txt"
extraParams=${work}/structure/extraparams.txt

input=${work}/stacks/populations/"${species}${file}"/"populations.structure" #the script ${work}/scripts/format_structure_file.sh used to remove first line and change location designations to integers
output=${work}/structure/"${species}${file}_K${MAXPOPS}_replicate_${replicate}"

mkdir -p "$output"
cd "$output"

$STRUCTURE \
	-K "$MAXPOPS" \
	-L "$NUMLOCI" \
	-i "$input" \
	-o "$output" \
	-m "$mainParams" \
	-e "$extraParams"
