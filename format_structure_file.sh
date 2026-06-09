#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=12:00:00
#$ -N reformat_s
#$ -pe omp 4
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu

file=/projectnb/ceeglab/lindens/stacks/populations/"sexpunctata300_r0.5"/"populations.structure"

sed -i '1d' "${file}"

awk '
{
    gsub(/aa/, 10)
    gsub(/fr/, 11)
    gsub(/wb/, 12)
    gsub(/ln/, 13)
    gsub(/cp/, 14)
    gsub(/lw/, 15)
    gsub(/wm/, 16)
    gsub(/mv/, 17)
    print
}
' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
