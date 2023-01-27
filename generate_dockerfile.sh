#!/bin/bash

# halt, if script produces an error
set -e

# generate a .yml file for conda using the tcy submodule or use the .yml file provided as argument to this script
if [ -n "$1" ]; then
    conda_yml_file=$1
    echo "Using the provided .yml file"
else
    python ./tcy/tcy.py csp docker linux --ignore_yml_name --no_pip_requirements_file --tsv_path ./tcy/packages.tsv --yml_dir .
    conda_yml_file=environment.yml
    echo "Using the .yml file as generated with the tcy submodule"
fi

echo "Adding yaml-file ${conda_yml_file} to be installed in conda. Make sure that the .yml file does not contain a name nor a prefix"

# function to create a dockerfile
generate_docker() {
    docker run -i --rm repronim/neurodocker:0.9.4 generate docker \
        --base-image neurodebian:stretch-non-free \
        --yes \
        --pkg-manager apt \
        --install opts="--quiet" \
            gcc \
            g++ \
            octave \
        --spm12 \
            version=r7771 \
        --freesurfer \
            version=7.1.1 \
        --copy $conda_yml_file /tmp/ \
        --miniconda \
            version=latest \
            yaml_file=/tmp/$conda_yml_file \
            env_name=csp \
        --user csp \
        --run 'mkdir /home/csp/data && chmod 777 /home/csp/data && chmod a+s /home/csp/data' \
        --run 'mkdir /home/csp/output && chmod 777 /home/csp/output && chmod a+s /home/csp/output' \
        --run 'mkdir /home/csp/code && chmod 777 /home/csp/code && chmod a+s /home/csp/code' \
        --run 'mkdir /home/csp/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > home/csp/.jupyter/jupyter_notebook_config.py' \
        --workdir /home/csp/code \
        --run 'echo source activate csp >> /home/csp/.bashrc'
}

# generate Dockerfile
generate_docker > Dockerfile
