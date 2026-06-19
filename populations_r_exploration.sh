#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=96:00:00
#$ -N populations
#$ -t 217-648
#$ -pe omp 8
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs

module load stacks

#get parameter values from this csv file which contains four columns: the job number, the run name to get data from, the r value, and a blank column for retained reads
parameterValues=/projectnb/ceeglab/lindens/stacks/parameter_exploration/populations_100k.csv
read sample species r min_maf < <(awk -F',' -v t="$SGE_TASK_ID" 'NR>1 && $1==t {print $2, $3, $4, $5}' "$parameterValues")

popmap=/projectnb/ceeglab/lindens/stacks/popmaps/"${species}_100k_popmap.txt"
samples=/projectnb/ceeglab/lindens/stacks/denovo/100k/"${sample}"

output=/projectnb/ceeglab/lindens/stacks/populations/"${sample}_r${r}"
mkdir -p "$output"

populations -P "$samples" -t 8 -O "$output" -M "$popmap" -r "$r" --min_maf "$min_maf" --vcf --genepop --structure --radpainter --fstats

#extract the retained reads from the output file by getting the second value in the line with "Kept" as its first value
reads=$(grep "Kept" "$output"/* | awk '{print $2}')

#rebuild the input file with the retained reads in the corresponding row
tmpfile=$(mktemp)

awk -F',' -v OFS=',' -v t="$SGE_TASK_ID" -v val="$reads" '
NR==1 {print; next}
$1==t {$6=val}
{print}
' "$parameterValues" > "$tmpfile"

mv "$tmpfile" "$parameterValues"
