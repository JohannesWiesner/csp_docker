#!/bin/bash
openneuro-py download \
--dataset ds004302 \
--include=sub-01/anat/sub-01_T1w.nii.gz \
--include=sub-01/func/sub-01_task-speech_bold.nii.gz \
--target_dir=testing/data/tmp &&
cp testing/data/tmp/sub-01/anat/sub-01_T1w.nii.gz testing/data/anatomical.nii.gz &&
cp testing/data/tmp/sub-01/func/sub-01_task-speech_bold.nii.gz testing/data/functional.nii.gz &&
rm -r testing/data/tmp &&
gzip -d testing/data/anatomical.nii.gz &&
gzip -d testing/data/functional.nii.gz

