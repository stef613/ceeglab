#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=12:00:00
#$ -N missingness_g2
#$ -pe omp 4
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu

module load vcftools

work=/projectnb/ceeglab/lindens/stacks/populations
run="guttata300_r0.5"

vcftools \
	--vcf "${work}"/"${run}"/populations.snps.vcf \
	--missing-indv \
	--out "${work}"/"${run}"/individual_missingness
