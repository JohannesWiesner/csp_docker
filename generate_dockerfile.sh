#!/bin/bash

# halt, if script produces an error
set -e

################################################################################################
# Parse user input #############################################################################
################################################################################################

# Set defaults: If not otherwise specified with -t and -y flags, do not run in testing mode
# and use environment.yml as provided by the tcy-submodule
testing=false
python ./tcy/tcy.py linux --tsv_path ./tcy/packages.tsv && yaml_file=environment.yml

while getopts 'ty:' OPTION; do
  case "$OPTION" in
    t)
      testing=true
      yaml_file=test.yml
      ;;

    y)
      yaml_file="$OPTARG"
      ;;

    ?)
      echo "script usage: $(basename $0) [-t] [-y /path/to/file.yml]" >&2
      exit 1
      ;;
  esac
done

################################################################################################
# Function to create a Dockerfile ##############################################################
################################################################################################

generate_docker() {
    docker run -i --rm repronim/neurodocker:0.9.4 generate docker \
        --base-image neurodebian:stretch-non-free \
        --pkg-manager apt \
        --install opts="--quiet" \
            gcc \
            g++ \
            octave \
        --spm12 version=r7771 \
        --freesurfer version=7.1.1 \
        --copy $yaml_file /tmp/ \
        --miniconda \
            version=latest \
            yaml_file=/tmp/$yaml_file \
            env_name=csp \
        --run 'mkdir /code && chmod 777 /code && chmod a+s /code' \
        --run 'mkdir /data && chmod 777 /data && chmod a+s /data' \
        --run 'mkdir /cache && chmod 777 /cache && chmod a+s /cache' \
        --run 'mkdir /output && chmod 777 /output && chmod a+s /output' \
        --run 'mkdir ~root/.jupyter' \
        --run 'echo c.NotebookApp.ip = \"0.0.0.0\" > ~root/.jupyter/jupyter_notebook_config.py' \
        --run 'echo c.NotebookApp.allow_root=True >> ~root/.jupyter/jupyter_notebook_config.py' \
        --run 'echo source activate csp >> ~root/.bashrc' \
        --workdir '/code'
}

################################################################################################
# Run functions as required ####################################################################
################################################################################################

build_docker() {
    docker build -t csp_docker:test .
}

run_docker(){
    docker run -ti --rm \
    -v ${PWD}/testing/code:/code  \
    -v ${PWD}/testing/data:/data \
    -v ${PWD}/testing/cache:/cache \
    -v ${PWD}/testing/output:/output \
    -p 8888:8888 \
    csp_docker:test
}

if $testing
then
  echo "Running in testing mode: generate Dockerfile with $yaml_file as input, build image and run as container"
  generate_docker > Dockerfile && build_docker && run_docker
else
  echo "Running in normal mode: only generate Dockerfile with $yaml_file as input"
  generate_docker > Dockerfile
fi
