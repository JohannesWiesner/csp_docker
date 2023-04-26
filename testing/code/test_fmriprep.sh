#!/bin/bash

# Run a minimal fmriprep-workflow:
# 1.) Only anatomical workflow
# 2.) Skip Freesurfer

# first, we use the following commands to first find the location of this script
# and the to automatically define the path/to/testing
# Taken from: https://stackoverflow.com/a/1482133/8792159
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
TESTING_DIR="$(dirname $SCRIPT_DIR)"

# Make sure that FS_LICENSE points to a valid freesurfer license
echo "This is the fs license: ${FS_LICENSE}"

docker run -ti --rm \
-v ${TESTING_DIR}/data/bids:/data:ro \
-v ${TESTING_DIR}/output:/out \
-v ${TESTING_DIR}/cache:/work \
-v ${FS_LICENSE}:/opt/freesurfer/license.txt \
-u $(id -u):$(id -g) \
nipreps/fmriprep:23.0.2 \
/data /out participant \
--skip_bids_validation \
--anat-only \
--fs-no-reconall \
--participant_label 01 \
--work-dir /work




