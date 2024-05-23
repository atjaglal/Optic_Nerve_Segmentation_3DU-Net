#!/bin/bash

SUBJID=$1           # Subject name
DATADIR=$2          # Directory to processed data
WORKDIR=$3          # Directory to save cropped images

SUBDIR=${DATADIR}/$SUBJID       # Current subject directory

# Exit if subject is already cropped
if [ -d ${WORKDIR}/$SUBJID ];then
	echo "This subject is already cropped"
	exit
fi

# If not, create folder
mkdir $WORKDIR/$SUBJID

# Get center points of eyes in rotated image
ptumor=(`cat ${SUBDIR}/coordinates.txt | sed -n 4p`)

# Round pixel coordinates
tumorx=(`printf "%.0f\n" ${ptumor[0]}`)
tumory=(`printf "%.0f\n" ${ptumor[1]}`)
tumorz=(`printf "%.0f\n" ${ptumor[2]}`)

# Centerpoint between two eyes
Cx=$( echo "($tumorx - $OSx)/2 + $OSx" | bc -l )
Cx=(`printf "%.0f\n" $Cx`)
Cy=${OSy}

z=(`fslinfo ${SUBDIR}/fiesta.nii.gz | sed -n 4p`)
z=${z[1]}
Cz=$(( $z / 2 ))

# Minimum values of bounding box
zmin=$(( $Cz - 56))
ymin_OS=$(( OSy - 170 ))
ymin_tumor=$(( tumory - 170 ))
xmin_OS=$(( $Cx - 144))
xmin_tumor=$Cx

# Crop scans to VOIs
fslroi ${SUBDIR}/fiesta.nii.gz ${WORKDIR}/$SUBJID/fiesta_tumor.nii.gz $xmin_tumor 144 $ymin_tumor 240 $zmin 112 

# Crop GT to VOI
fslroi ${SUBDIR}/gt_tumor-label.nii.gz ${WORKDIR}/$SUBJID/gt_tumor-label.nii.gz $xmin_tumor 144 $ymin_tumor 240 $zmin 112 
