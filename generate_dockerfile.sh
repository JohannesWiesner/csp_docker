#!/bin/bash

# halt, if script produces an error
set -e

#Credits for usage of getopts: https://gist.github.com/magnetikonline/22c1eb412daa350eeceee76c97519da8
ARGUMENT_LIST=(
  "mode"
  "yaml-file"
)

#set defaults
mode="normal"
python ./tcy/tcy.py linux --tsv_path ./tcy/packages.tsv
conda_yml_file=environment.yml
echo "HINT:
    The script defaults to just create the Dockerfile and use the conda environment created by the submodule.
    To build and run the the docker container set the argument '--mode testing'.
    To give a custom yml-file set the argument '--yaml-file pathtofile.yml (Make sure that the .yml file does not contain a name nor a prefix)"

# read arguments
opts=$(getopt \
  --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
  --name "$(basename "$0")" \
  --options "" \
  -- "$@"
)

eval set --$opts

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      if [ $2 = "normal" ]
      then
        #echo "The execution mode has been set to 'normal'"
        mode="normal"
      elif [ $2 = "testing" ]
      then
        #echo "The execution mode has been set to 'testing'"
        mode="testing"
      else
        echo "Error: Invalid value for argument '--mode'! The implemented modes are 'normal' and 'testing'"
        exit
    fi
      shift 2
      ;;

    --yaml-file)
      if [ -e $2 ]
      then
        #echo "The path for the used yaml-file is $2" 
        conda_yml_file=$2
      else
        echo "Error: No valid path provided for argument '--yaml-file'!"
        exit
      fi
      shift 2
      ;;

    *)
      break
      ;;
  esac
done

echo "SETTINGS: The execution mode of the script is $mode and the path to the conda yaml file is $conda_yml_file."

# function to create a dockerfile
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
        --copy $conda_yml_file /tmp/ \
        --miniconda \
            version=latest \
            yaml_file=/tmp/$conda_yml_file \
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

build_docker() {
    docker build -t csp_docker:test .
}

run_docker(){
    docker run -t -i --rm -p 8888:8888 -v ${PWD}/testing/code:/code -v ${PWD}/testing/data:/data -v ${PWD}/testing/output:/output csp_docker:test
}
# generate Dockerfile

if [ $mode = "testing" ]
then
    generate_docker > Dockerfile
    echo "SUCCESS: Dockerfile generated!"
    build_docker
    echo "SUCCESS: Docker image built!"
    run_docker
elif [ $mode = "normal" ]
then
    generate_docker > Dockerfile
    echo "SUCCESS: Dockerfile generated!"
fi

