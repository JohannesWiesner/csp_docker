#!/bin/bash

# halt, if script produces an error
set -e
#################################
##      General remarks        ##
#################################
# + baseimage: apparantly different options like spm12, afni, and fsl do not run under debian bookworm, thus stretch as base
# + when installing packages with apt-get in cspdebian, the user is asked whether to take part in a package usage survey, which interferes with the
#   build, thus we set "DEBIAN_FRONTEND='noninteractive'"

#################################
## Used resources in Container ##
#################################
# + tbd tried: rstudio,  surf ice, MRICroGl (insted of MRICron), cat12
# + to be tried again as parameters of cspdocker (see snippets below):
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
# + test whether installation of afni, ants, fsl, mricron via the cspdocker options and not the repositories of cspdebian gets software more up to date

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

YAML_FILE=$1
echo "Adding yaml-file ${YAML_FILE} to be installed in conda. Make sure that no prefix and no name are defined!"

# function to create a dockerfile
generate_docker() {
    docker run -i --rm repronim/neurodocker:0.9.1 generate docker \
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
        --user csp \
        --run 'rm -rf /opt/conda/pkgs/*' \
        --run 'mkdir /home/csp/data && chmod 777 /home/csp/data && chmod a+s /home/csp/data' \
        --run 'mkdir /home/csp/output && chmod 777 /home/csp/output && chmod a+s /home/csp/output' \
        --run 'mkdir /home/csp/code && chmod 777 /home/csp/code && chmod a+s /home/csp/code' \
        --run 'mkdir /home/csp/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > home/csp/.jupyter/jupyter_notebook_config.py'
}

# generate Dockerfile
generate_docker > Dockerfile
