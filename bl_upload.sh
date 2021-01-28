#!/bin/bash

#set -x

# top variables (user input)
topPath=$1
subjectID=$2
session_tag=$3
session_id="`echo ${session_tag:(-1)}`" # grabs last character which should be the session number
dwi_reconst_tag=$4
#projectID="59cbd18ff32356076a887fe4"
projectID=$5

# grab data
t1s=(`ls ${topPath}/niftis/*tfl3d_nsIR_sag*.nii`)
t1s_json=(`ls ${topPath}/niftis/*tfl3d_nsIR_sag*.json`)

t2s=(`ls ${topPath}/niftis/*T2w*.nii`)
t2s_json=(`ls ${topPath}/niftis/*T2w*.json`)

dwis_ap=(`ls ${topPath}/niftis/*DWI_dir198_AP*.nii`)
dwis_ap_bvals=(`ls ${topPath}/niftis/*DWI_dir198_AP*.bval`)
dwis_ap_bvecs=(`ls ${topPath}/niftis/*DWI_dir198_AP*.bvec`)
dwis_ap_json=(`ls ${topPath}/niftis/*DWI_dir198_AP*.json`)

dwis_pa=(`ls ${topPath}/niftis/*DWI_dir198_PA*.nii`)
dwis_pa_bvals=(`ls ${topPath}/niftis/*DWI_dir198_PA*.bval`)
dwis_pa_bvecs=(`ls ${topPath}/niftis/*DWI_dir198_PA*.bvec`)
dwis_pa_json=(`ls ${topPath}/niftis/*DWI_dir198_PA*.json`)

#upload t1s
for i in ${!t1s[@]}
do
	if [[ ! ${t1s[${i}]:(-3)} == '.gz' ]]; then 
		if [ ! -f ${t1s[${i}]}.gz ]; then
			gzip -c ${t1s[${i}]} > ${t1s[${i}]}.gz
		fi
		imgsess_id=`echo ${t1s[${i}]##*_}` # grabs everything after last underscore
		imgsess_tag="image_${imgsess_id%.nii}" # grabs the session number before the .nii extension
		echo "$imgsess_tag"

		# check if data has been uploaded to bl already
		bl_check=(`bl dataset query --project ${projectID} --subject ${subjectID} --session ""${session_tag}"" --datatype neuro/anat/t1w --datatype_tag ""${imgsess_tag}"" --datatype_tag ""session_${session_id}"" --json`)
		echo ${bl_check}
		if [[ "${bl_check}" == '[]' ]]; then
			echo "uploading ${t1s[${i}]}"
			bl data upload --project ${projectID} \
				--subject ${subjectID} \
				--session ""${session_tag}"" \
				--datatype neuro/anat/t1w \
				--t1 ${t1s[$i]}.gz \
				--meta ${t1s_json[$i]} \
				--datatype_tag ""${imgsess_tag}"" \
				--datatype_tag ""session_${session_id}"" \
				--tag ""${imgsess_tag}"" \
				--tag ""session_${session_id}""
			echo "uploading complete"
		fi
	fi
done

#upload t2s
for i in ${!t2s[@]}
do
	if [[ ! ${t2s[${i}]:(-3)} == '.gz' ]]; then
		echo "uploading ${t2s[${i}]}"
		if [ ! -f ${t2s[${i}]}.gz ]; then
			gzip -c ${t2s[${i}]} > ${t2s[${i}]}.gz
		fi
		imgsess_id=`echo ${t2s[${i}]##*_}` # grabs everything after last underscore
		imgsess_tag="image_${imgsess_id%.nii}" # grabs the session number before the .nii extension
		
		# check if data has been uploaded to bl already
		bl_check=(`bl dataset query --project ${projectID} --subject ${subjectID} --session ""${session_tag}"" --datatype neuro/anat/t2w --datatype_tag ""${imgsess_tag}"" --datatype_tag ""session_${session_id}"" --json`)
		if [[ ${bl_check} == '[]' ]]; then			
			echo "uploading ${t2s[${i}]}"
			bl data upload --project ${projectID} \
				--subject ${subjectID} \
				--session ""${session_tag}"" \
				--datatype neuro/anat/t2w \
				--t2 ${t2s[$i]}.gz \
				--meta ${t2s_json[$i]} \
				--datatype_tag ""${imgsess_tag}"" \
				--datatype_tag ""session_${session_id}"" \
				--tag ""${imgsess_tag}"" \
				--tag ""session_${session_id}""
			echo "uploading complete"
		fi
	fi
done

#upload dwi ap
for i in ${!dwis_ap[@]}
do
	if [[ ! ${dwis_ap[${i}]:(-3)} == '.gz' ]]; then
		if [ ! -f ${dwis_ap[${i}]}.gz ]; then
			gzip -c ${dwis_ap[${i}]} > ${dwis_ap[${i}]}.gz
		fi
		imgsess_id=`echo ${dwis_ap[${i}]##*_}` # grabs everything after last underscore
		imgsess_tag="image_${imgsess_id%.nii}" # grabs the session number before the .nii extension

		# check if data has been uploaded to bl already
		bl_check=(`bl dataset query --project ${projectID} --subject ${subjectID} --session ""${session_tag}"" --datatype neuro/dwi --datatype_tag ""${imgsess_tag}"" --datatype_tag ""session_${session_id}"" --tag "AP" --json`)
		if [[ ${bl_check} == '[]' ]]; then
			echo "uploading ${dwis_ap[${i}]}"
			bl data upload --project ${projectID} \
				--subject ${subjectID} \
				--session ""${session_tag}"" \
				--datatype neuro/dwi \
				--dwi ${dwis_ap[$i]}.gz \
				--bvals ${dwis_ap_bvals[$i]} \
				--bvecs ${dwis_ap_bvecs[$i]} \
				--meta ${dwis_ap_json[$i]} \
				--datatype_tag ""${imgsess_tag}"" \
				--datatype_tag ""session_${session_id}"" \
				--tag ""${imgsess_tag}"" \
				--tag ""session_${session_id}"" \
				--tag "AP" \
				--tag "${dwi_reconst_tag}" \
			echo "uploading complete"
		fi
	fi
done

#upload dwi pa
for i in ${!dwis_pa[@]}
do
	if [[ ! ${dwis_pa[${i}]:(-3)} == '.gz' ]]; then
		if [ ! -f ${dwis_pa[${i}]}.gz ]; then 
			gzip -c ${dwis_pa[${i}]} > ${dwis_pa[${i}]}.gz
		fi
		imgsess_id=`echo ${dwis_pa[${i}]##*_}` # grabs everything after last underscore
		imgsess_tag="image_${imgsess_id%.nii}" # grabs the session number before the .nii extension

		# check if data has been uploaded to bl already
		bl_check=(`bl dataset query --project ${projectID} --subject ${subjectID} --session ""${session_tag}"" --datatype neuro/dwi --datatype_tag ""${imgsess_tag}"" --datatype_tag ""session_${session_id}"" --tag "PA" --json`)
		if [[ ${bl_check} == '[]' ]]; then
			echo "uploading ${dwis_pa[${i}]}"
			bl data upload --project ${projectID} \
				--subject ${subjectID} \
				--session ""${session_tag}"" \
				--datatype neuro/dwi \
				--dwi ${dwis_pa[$i]}.gz \
				--bvals ${dwis_pa_bvals[$i]} \
				--bvecs ${dwis_pa_bvecs[$i]} \
				--meta ${dwis_pa_json[$i]} \
				--datatype_tag ${imgsess_tag} \
				--datatype_tag ""session_${session_id}"" \
				--tag ""${imgsess_tag}"" \
				--tag ""session_${session_id}"" \
				--tag "PA" \
				--tag "${dwi_reconst_tag}" \
			echo "uploading complete"
		fi
	fi
done
