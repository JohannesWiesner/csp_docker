#!/bin/bash

# halt, if script produces an error
set -e

#################################
## Used resources in Container ##
#################################
# + tbd tried: rstudio,  surf ice, MRICroGl (insted of MRICron), cat12

#################################
##      Code snippets          ##
#################################
#       to be tried again:
#        --afni \
#            version=latest \
#        --run 'conda activate csp_surname_name' \
#        --spm12 \
#            version=r7771 \
#       --fsl \
#            version=6.0.4
#       --ants \
#            version=2.3.1 \
#        --mricron \
#            version=1.0.20190902 \
# + conda: dependant on the first parameter
#        yaml_file=environment-short.yml \
#  --run '/opt/miniconda-latest/bin/conda init bash' \
#        --run '/opt/miniconda-latest/bin/conda activate example-environment' \
# --user csp \
# --env PATH='/opt/miniconda-latest/bin:$PATH' \
# --entrypoint 'jupyter-notebook'
#
# --run 'mkdir /home/csp/localdata && chmod 777 /home/csp/localdata && chmod a+s /home/csp/localdata' \
# --copy example-env.yml /tmp/ \
# --user root \
# --run '/opt/miniconda-latest/bin/conda config --set channel_priority strict' \
# --run '/opt/miniconda-latest/bin/conda env update -n base --file /home/csp/localdata/example-env.yml' \
#
# --workdir /home/csp/code \ 

if [ -n "$1" ]; then
    conda_yml_file=$1
    echo "Using the provided .yml file"
else
    python ./tcy/tcy.py csp docker linux --ignore_yml_name --no_pip_requirements_file --tsv_path ./tcy/packages.tsv --yml_dir .
    conda_yml_file=./environment.yml
    echo "Using the .yml file as generated with the tcy submodule"
fi


echo "Adding yaml-file ${conda_yml_file} to be installed in conda. Make sure that the .yml file does not contain a name nor a prefix"

# function to create a dockerfile
generate_docker() {
    docker run -i --rm repronim/neurodocker:0.9.4 generate docker \
        --base-image neurodebian:stretch-non-free \
        --arg DEBIAN_FRONTEND='noninteractive' \
        --pkg-manager apt \
        --install opts="--quiet" \
            gcc \
            g++ \
            octave \
            afni \
            ants \
            fsl \
            mricron \
        --spm12 \
            version=r7771 \
        --freesurfer \
            version=7.1.1 \
        --miniconda \
            version=latest \
        --copy $conda_yml_file /tmp/ \
        --run "conda env update -n base --file /tmp/${conda_yml_file}" \
        --user csp \
        --run 'mkdir /home/csp/data && chmod 777 /home/csp/data && chmod a+s /home/csp/data' \
        --run 'mkdir /home/csp/output && chmod 777 /home/csp/output && chmod a+s /home/csp/output' \
        --run 'mkdir /home/csp/code && chmod 777 /home/csp/code && chmod a+s /home/csp/code' \
        --run 'mkdir /home/csp/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > home/csp/.jupyter/jupyter_notebook_config.py'
}

# generate Dockerfile
generate_docker > Dockerfile
