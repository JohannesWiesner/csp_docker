#!/bin/bash

# This script will use openneuro-py to download some data files
# that can be used for testing purposes. You need to have
# openneuro-py installed in order to run it.
# See: https://github.com/hoechenberger/openneuro-py#installation

###############################################################
# 1.) Download an anatomical and functional file from openneuro
# We will use this for very basic tests that do not
# require BIDS-conformity. We will unzip the images because
# SPM can't handle .gz files.
###############################################################

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

###############################################################
# 2.) Download a BIDS-dataset with only one subject. With this
# we can test applications that require BIDS-conformity
###############################################################

openneuro-py download \
--dataset ds004302 \
--include=sub-01 \
--target_dir=testing/data/bids
