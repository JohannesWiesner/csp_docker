#!/bin/bash

# halt if script produces error
set -e

# Generate Dockerfile
generate_docker() {
  docker run --rm kaczmarj/neurodocker:0.7.0 generate docker \
           --base neurodebian:stretch-non-free \
           --pkg-manager apt \
           --install apt_opts='--quiet' convert3d ants fsl gcc g++ graphviz tree \
                     git-annex-standalone vim emacs-nox nano less ncdu \
                     tig git-annex-remote-rclone octave netbase ca-certificates \
           --add-to-entrypoint "source /etc/fsl/fsl.sh" \
           --spm12 version=r7771 curl_opts="--insecure" \
           --user=neuro \
           --workdir '/home/neuro' \
           --miniconda \
             conda_install="python=3.7 pytest jupyter jupyterlab jupyter_contrib_nbextensions
                            traits pandas matplotlib scikit-learn scikit-image seaborn nbformat nb_conda" \
             pip_install="https://github.com/nipy/nipype/tarball/master
                          https://github.com/INCF/pybids/tarball/0.7.1
                          nilearn datalad[full] nipy duecredit nbval niflow-nipype1-workflows" \
             create_env="neuro" \
             activate=True \
           --env LD_LIBRARY_PATH="/opt/miniconda-latest/envs/neuro:$LD_LIBRARY_PATH" \
           --run-bash "source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main" \
           --user=root \
           --run 'mkdir /data && chmod 777 /data && chmod a+s /data' \
           --run 'mkdir /output && chmod 777 /output && chmod a+s /output' \
           --run 'mkdir /home/neuro/workdir && chmod 777 /home/neuro/workdir && chmod a+s /home/neuro/workdir' \
           --run 'chown -R neuro /home/neuro/workdir' \
           --run 'rm -rf /opt/conda/pkgs/*' \
           --user=neuro \
           --run 'mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > ~/.jupyter/jupyter_notebook_config.py' \
           --workdir '/home/neuro/workdir' \
           --cmd jupyter-notebook

# Generate Singularity File
generate_singularity() {
  docker run --rm kaczmarj/neurodocker:0.7.0 generate singularity \
           --base neurodebian:stretch-non-free \
           --pkg-manager apt \
           --install apt_opts='--quiet' convert3d ants fsl gcc g++ graphviz tree \
                     git-annex-standalone vim emacs-nox nano less ncdu \
                     tig git-annex-remote-rclone octave netbase ca-certificates \
           --add-to-entrypoint "source /etc/fsl/fsl.sh" \
           --spm12 version=r7771 curl_opts="--insecure" \
           --user=neuro \
           --workdir '/home/neuro' \
           --miniconda \
             conda_install="python=3.7 pytest jupyter jupyterlab jupyter_contrib_nbextensions
                            traits pandas matplotlib scikit-learn scikit-image seaborn nbformat nb_conda" \
             pip_install="https://github.com/nipy/nipype/tarball/master
                          https://github.com/INCF/pybids/tarball/0.7.1
                          nilearn datalad[full] nipy duecredit nbval niflow-nipype1-workflows" \
             create_env="neuro" \
             activate=True \
           --env LD_LIBRARY_PATH="/opt/miniconda-latest/envs/neuro:$LD_LIBRARY_PATH" \
           --run-bash "source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main" \
           --user=root \
           --run 'mkdir /data && chmod 777 /data && chmod a+s /data' \
           --run 'mkdir /output && chmod 777 /output && chmod a+s /output' \
           --run 'mkdir /home/neuro/workdir && chmod 777 /home/neuro/workdir && chmod a+s /home/neuro/workdir' \
           --run 'chown -R neuro /home/neuro/workdir' \
           --run 'rm -rf /opt/conda/pkgs/*' \
           --user=neuro \
           --run 'mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > ~/.jupyter/jupyter_notebook_config.py' \
           --workdir '/home/neuro/workdir'
}

generate_docker > Dockerfile
generate_singularity > Singularity

"$@"