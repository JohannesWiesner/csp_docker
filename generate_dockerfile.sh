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
        --user csp \
        --run 'mkdir /home/csp/code && chmod -R 777 /home/csp/code' \
        --run 'mkdir /home/csp/data && chmod -R 777 /home/csp/data' \
        --run 'mkdir /home/csp/cache && chmod -R 777 /home/csp/cache' \
        --run 'mkdir /home/csp/output && chmod -R 777 /home/csp/output' \
        --run 'mkdir /home/csp/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > home/csp/.jupyter/jupyter_notebook_config.py' \
        --workdir /home/csp/code \
        --run 'echo source activate csp >> /home/csp/.bashrc'
}

################################################################################################
# Run functions as required ####################################################################
################################################################################################

build_docker() {
    docker build -t csp_docker:test .
}

run_docker(){
    docker run -ti --rm \
    -v ${PWD}/testing/code:/home/csp/code  \
    -v ${PWD}/testing/data:/home/csp/data \
    -v ${PWD}/testing/cache:/home/csp/cache \
    -v ${PWD}/testing/output:/home/csp/output \
    -p 8888:8888 \
    -u csp:$(getent group docker | cut -d: -f3) \
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
