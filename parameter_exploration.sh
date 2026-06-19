#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=12:00:00
#$ -N parameter_exploration
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -pe omp 8
#$ -m be
#$ -M lindens@bu.edu

work=/projectnb/ceeglab/lindens/stacks/denovo/100k
out=/projectnb/ceeglab/lindens/stacks/parameter_exploration/coverage_100k.csv

#csv header
echo "run,m,M,n,mean,stdev,min,max" > "$out"

#go through each run folder
for run in "$work"/*; do
	log="$run/denovo_map.log"

	line=$(grep "denovo_map.pl" "$log")

	m=$(echo "$line" | sed -n 's/.*-m \([0-9]\+\).*/\1/p')
	M=$(echo "$line" | sed -n 's/.*-M \([0-9]\+\).*/\1/p')
	n=$(echo "$line" | sed -n 's/.*-n \([0-9]\+\).*/\1/p')

	cov_line=$(grep "effective per-sample coverage" "$log")

	mean=$(echo "$cov_line" | grep -oP '(?<=mean=)[0-9.]+')
	stdev=$(echo "$cov_line" | grep -oP '(?<=stdev=)[0-9.]+')
	min=$(echo "$cov_line" | grep -oP '(?<=min=)[0-9.]+')
	max=$(echo "$cov_line" | grep -oP '(?<=max=)[0-9.]+')

	echo "$(basename "$run"),$m,$M,$n,$mean,$stdev,$min,$max" >> "$out"
done
