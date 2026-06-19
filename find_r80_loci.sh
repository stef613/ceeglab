#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=12:00:00
#$ -N parameter_exploration
#$ -j y
#$ -pe omp 8
#$ -m be
#$ -M lindens@bu.edu

module load stacks

work=/projectnb/ceeglab/lindens/stacks/denovo
out=/projectnb/ceeglab/lindens/stacks/logs/r80_loci.csv

#csv header
echo "run,r80" > "$out"

#go through each run
for run in "$work"/*; do
	runName=$(basename "$run")
	#specify output
	output=/projectnb/ceeglab/lindens/stacks/populations/"$runName"

	#specify popmap
	firstChar=${runname:0:1}

	if [[ "$first_char" == "g" ]]; then
    		popmap=/projectnb/ceeglab/lindens/stacks/popmaps/guttata_popmap.txt
	elif [[ "$first_char" == "s" ]]; then
    		popmap=/projectnb/ceeglab/lindens/stacks/popmaps/sexpunctata_popmap.txt
	fi

	#run populations with -r 0.8
	populations -P "$run" -t 8 --fstats -O "$output" -M "$popmap" -r 0.8 --vcf --genepop

	#extract r80 value

	#write r80 value to csv file
	echo "$(basename "$run"),$r80" >> "$out"

done
