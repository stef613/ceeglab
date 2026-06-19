#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=15:00:00
#$ -N quality_report
#$ -j y
#$ -pe omp 4
#SBATCH --mail-type=END
#SBATCH --mail-user=lindens@bu.edu

WORKD="/projectnb/ceeglab/lindens/fastp_trimmed/fastp_reports"
OUT="/projectnb/ceeglab/lindens/fastp_trimmed/fastp_reports/fastp_summary.csv"

echo "sample,state,reads" > "$OUT"

for file in "$WORKD"/*.json; do
	#before=$(sed -n '/id="before_filtering_summary"/,/\/div/p' "$file" | grep -oP '(?<=total reads:</td><td class="col2">)\d+\.\d+')

	#after=$(sed -n '/id="after_filtering_summary"/,/\/div/p' "$file" | grep -oP '(?<=total reads:</td><td class="col2">)\d+\.\d+')

	before=$(jq -r '.summary.before_filtering.total_reads' "$file")

	after=$(jq -r '.summary.after_filtering.total_reads' "$file")

	echo "$(basename "$file"),"before",$before" >> "$OUT"
	echo "$(basename "$file"),"after",$after" >> "$OUT"
done
