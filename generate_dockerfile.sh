#!/bin/bash

# halt, if script produces an error
set -e
#################################
##      General remarks        ##
#################################
# + baseimage: apparantly different options like spm12, afni, and fsl do not run under debian bookworm, thus stretch as base
# + when installing packages with apt-get in neurodebian, the user is asked whether to take part in a package usage survey, which interferes with the
#   build, thus we set "DEBIAN_FRONTEND='noninteractive'"

#################################
## Used resources in Container ##
#################################
# + tbd tried: rstudio,  surf ice, MRICroGl (insted of MRICron), cat12
# + to be tried again as parameters of neurodocker (see snippets below):
#       --afni
#       --spm12 \
#       --fsl \
#       --ants \
#       --mricron \

#################################
##           TBD               ##
#################################
# + set up IDE (maybe VSC (https://code.visualstudio.com/docs/devcontainers/tutorial), VSCodium, jupyter notebook, spyder?)
# + make sure conda env is activated or added to path
# + generalize yml-file for conda environment so that a yml-file can be given as a parameter for script
# + test whether installation of afni, ants, fsl, mricron via the neurodocker options and not the repositories of neurodebian gets software more up to date

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
# --user neuro \
# --env PATH='/opt/miniconda-latest/bin:$PATH' \
# --entrypoint 'jupyter-notebook'
#
# --run 'mkdir /home/neuro/localdata && chmod 777 /home/neuro/localdata && chmod a+s /home/neuro/localdata' \
# --copy example-env.yml /tmp/ \
# --user root \
# --run '/opt/miniconda-latest/bin/conda config --set channel_priority strict' \
# --run '/opt/miniconda-latest/bin/conda env update -n base --file /home/neuro/localdata/example-env.yml' \
#
# --workdir /home/neuro/code \ 

YAML_FILE=$1
echo "Adding yaml-file ${YAML_FILE} to be installed in conda. Make sure that no prefix and no name are defined!"

# function to create a dockerfile
generate_docker() {
    docker run -i --rm repronim/neurodocker:latest generate docker \
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
            conda_install="jupyter" \
        --copy $YAML_FILE /tmp/ \
        --run '/opt/miniconda-latest/bin/conda config --set channel_priority strict' \
        --run "/opt/miniconda-latest/bin/conda env update -n base --file /tmp/${YAML_FILE}" \
        --user neuro \
        --run 'rm -rf /opt/conda/pkgs/*' \
        --run 'mkdir /home/neuro/data && chmod 777 /home/neuro/data && chmod a+s /home/neuro/data' \
        --run 'mkdir /home/neuro/output && chmod 777 /home/neuro/output && chmod a+s /home/neuro/output' \
        --run 'mkdir /home/neuro/code && chmod 777 /home/neuro/code && chmod a+s /home/neuro/code' \
        --run 'mkdir /home/neuro/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > home/neuro/.jupyter/jupyter_notebook_config.py' \
        --entrypoint jupyter-notebook /home/neuro
}

# function to execute a create a singularity definition
generate_singularity() {
    docker run --rm repronim/neurodocker:0.7.0 generate singularity \
    
}
# run functions
generate_docker > Dockerfile
#generate_singularity > Singularity


