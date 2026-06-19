#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=12:00:00
#$ -N get_assembly_stats_fixed
#$ -t 1-2
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -pe omp 8

module load stacks

assemblies=/projectnb/ceeglab/lindens/stacks/denovo
parameterValues=/projectnb/ceeglab/lindens/stacks/parameter_exploration/assembly_stats.csv

#get parameter values from this csv file where each row contains the assembly name and the species, then there are places for the parameters, coverage data, and retained read data
read run species < <(awk -F',' -v t="$SGE_TASK_ID" 'NR>1 && $1==t {print $2, $3}' "$parameterValues")

#get popmap
popmap=/projectnb/ceeglab/lindens/stacks/popmaps/"${species}_popmap.txt"


#get coverage information
log="$assemblies/$run/denovo_map.log"

line=$(grep "denovo_map.pl" "$log")

m=$(echo "$line" | sed -n 's/.*-m \([0-9]\+\).*/\1/p')
M=$(echo "$line" | sed -n 's/.*-M \([0-9]\+\).*/\1/p')
n=$(echo "$line" | sed -n 's/.*-n \([0-9]\+\).*/\1/p')

cov_line=$(grep "effective per-sample coverage" "$log")

mean=$(echo "$cov_line" | grep -oP '(?<=mean=)[0-9.]+')
stdev=$(echo "$cov_line" | grep -oP '(?<=stdev=)[0-9.]+')
min=$(echo "$cov_line" | grep -oP '(?<=min=)[0-9.]+')
max=$(echo "$cov_line" | grep -oP '(?<=max=)[0-9.]+')


#run populations with the r values 0.2, 0.5, 0.8 and save the retained reads
for r in 0.8 0.5 0.2; do
	output=/projectnb/ceeglab/lindens/stacks/populations/"${run}_r${r}"

	mkdir -p "$output"
	
	populations -P "$assemblies/$run" -t 8 --fstats -O "$output" -M "$popmap" -r "$r" --min_maf 0.2 --vcf --genepop --structure
	
	case "$r" in
        	0.2) var="reads20" ;;
        	0.5) var="reads50" ;;
        	0.8) var="reads80" ;;
    	esac
	
	#extract the retained reads from the output file by getting the second value in the line with "Kept" as its first value
	reads=$(grep "Kept" "$output"/* | awk '{print $2}')

	declare "$var=$reads"
done


#rebuild the input file with the retained reads in the corresponding row
tmpfile=$(mktemp)

awk -F',' -v OFS=',' -v t="$SGE_TASK_ID" \
	-v m="$m" \
	-v M="$M" \
	-v n="$n" \
	-v mean="$mean" \
	-v stdev="$stdev" \
	-v min="$min" \
	-v max="$max" \
	-v r20="$reads20" \
	-v r50="$reads50" \
	-v r80="$reads80" '
NR==1 {print; next}
$1==t {$4=M $5=m $6=n $7=mean $8=stdev $9=min $10=max $11=r80 $12=r50 $13=r20}
{print}
' "$parameterValues" > "$tmpfile"

mv "$tmpfile" "$parameterValues"
