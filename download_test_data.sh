#!/bin/bash

# This script will use openneuro-py to download some data files
# that can be used for testing purposes. You need to have
# openneuro-py installed in order to run it.
# See: https://github.com/hoechenberger/openneuro-py#installation

###############################################################
# 1.) Download a BIDS-dataset with only one subject. With this
# we can test applications that require BIDS-conformity
###############################################################

openneuro-py download \
--dataset ds004302 \
--include=sub-01 \
--target_dir=testing/data/bids

###############################################################
# 2.) We will unzip the images because SPM can't handle .gz files.
###############################################################

mkdir testing/data/single_files && \
gzip -dc testing/data/bids/sub-01/anat/sub-01_T1w.nii.gz > testing/data/single_files/anatomical.nii && \
gzip -dc testing/data/bids/sub-01/func/sub-01_task-speech_bold.nii.gz > testing/data/single_files/functional.nii



