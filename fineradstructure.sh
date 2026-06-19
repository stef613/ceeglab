#!/bin/bash -l
#$ -P ceeglab
#$ -l h_rt=96:00:00
#$ -N fineradstructure_guttata
#$ -pe omp 8
#$ -j y
#$ -o /projectnb/ceeglab/lindens/stacks/logs
#$ -m be
#$ -M lindens@bu.edu

species="guttata200"

module load python2
module load fineradstructure/2019-02-11_gitd8fb782

work=/projectnb/ceeglab/lindens

radpainter=${work}/stacks/populations/"${species}_r0.6"/populations.haps.radpainter
RADpainter paint "${radpainter}" > ${work}/stacks/populations/"${species}_r0.6"/coancestry.out

coancestry=${work}/stacks/populations/"${species}_r0.6"/populations.haps_chunks.out

mcmcfile=${work}/stacks/populations/"${species}_r0.6"/"${species}.mcmc.xml"
mcmctreefile=${work}/stacks/populations/"${species}_r0.6"/"${species}.mcmcTree.xml"

finestructure -X -Y -x 100000 -y 100000 -z 1000 "${coancestry}" "${mcmcfile}"

finestructure -X -Y -m T -x 10000 "${coancestry}" "${mcmcfile}" "${mcmctreefile}"
