#!/bin/bash

irfDir="/N/dcwan/projects/irf/Prisma"
transferDir="/N/project/plab/acute_concussion/"

data=(`ls -d ${irfDir}/*Acute* ${irfDir}/*ACUTE*`)

for i in ${data[*]}
do
	if [ -d ${transferDir}/${i#${irfDir}/} ]; then
		mydirfil=`ls ${transferDir}/${i#${irfDir}/} | wc -l`
		irfdirfil=`ls ${i} | wc -l`
		if [[ ${mydirfil} -eq ${irfdirfil} ]]; then
			echo "${i} already exists and all files are accounted for. skipping"
		else
			echo "transfering ${i}"
			rsync -r -c --info=progress2 ${i} ${transferDir}/
		fi
	else	
		echo "transfering ${i}"
		rsync -r -c --info=progress2 ${i} ${transferDir}/
		echo "transfering complete"
	fi
done
