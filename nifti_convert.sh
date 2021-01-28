#!/bin/bash

topDir=$1
outputDir=$topDir/niftis

mkdir -p ${outputDir}

echo "converting ${topDir}"
dcm2niix -o ${outputDir} ${topDir}
echo "conversion complete"
