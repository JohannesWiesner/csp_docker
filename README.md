# Generating a docker image for the Complex Systems in Psychiatry Group (CSP)
## Aims
This repository uses both [neurodocker](https://github.com/ReproNim/neurodocker) and [tcy](https://github.com/JohannesWiesner/tcy) to create a standardized Docker-Image for the Complex Systems in Psychiatry Lab. It includes most of the software that the CSP-members need (A conda environment with Python & R  and a  bunch of of cool libraries, SPM, Freesurfer, etc.)

## Usage
If you just want to use the docker image, just can pull the latest version from [Docker Hub](https://hub.docker.com/r/johanneswiesner/csp/tags). You can pull the image by running:

`docker pull johanneswiesner/csp:x.x.x`

(where you replace `x.x.x` with latest currently available version).

### What's with Singularity?
Neurodocker is able to create `.sif` files. However, you can also convert the Docker image to a `.sif` file on the fly by running:

`singularity pull csp.sif docker://johanneswiesner/csp:x.x.x`

## Development
1. Clone this repository to your machine using `git clone --recurse-submodules https://github.com/JohannesWiesner/csp_docker.git`. This will automatically include the  `tcy` respository as a submodule.
2. Run `bash generate_dockerfile.sh` to create a Dockerfile using neurodocker. By default this will first  run the `tcy` submodule to create an `environment.yml` file. This file will then be used to create a `conda` environment within the Docker image with the standard packages for the CSP-members.
3. Build the image through `docker build -t xxx:xxx .`
4. Run image as a container using `docker run -t -i --rm -p 8888:8888 xxx:xxx`

### Speeding up development

Because it can be tedious to always execute steps 2-4 while developing and because the creation of conda environments can take quite long, we included two more options:

1. It is possible to provide a `.yml` file of your choice using:
 `bash generate_dockerfile.sh --yaml-file path/to/your/file.yml`. We included a `test_env.yml` file within this repository with only `jupyter-lab` and `nipype` serving as a [MVP](https://de.wikipedia.org/wiki/Minimum_Viable_Product).
2. It is possible to run steps 2-4 in one go by using:
`bash generate_dockerfile.sh --mode testing`. This will mount the subfolders of the included `/testing` directory to the container.

### Further notes to developers
1. Make sure you run `generate_dockerfile.sh`  and `docker build` on a regular basis (preferably after every single edit). This is tedious but in our experience, too many edits at once make it hard to debug what went wrong. The neurodocker image is still under heavy development which means that it is not guaranteed that every combination of arguments that you pass to `docker run -i --rm repronim/neurodocker:x.x.x generate docker` will lead to a bug-free Dockerfile.
2. The currently used base-image `neurodebian:stretch-non-free` is quite old and we would wish to switch to a newer version of neurodebian. However, with newer base images a lot of bugs happen and software like SPM12 could not be installed using the neurodocker flags. (This is also tightly related to the first point, so make sure the image can be built and the container runs error free when using a different base image).
3. Generally, there are two options to include neuroimaging software within the docker image. You can either use neurodebian as a base image and its included [APT](https://de.wikipedia.org/wiki/Advanced_Packaging_Tool) package manager to install software or you use the included flags of neurodocker (e.g. `--spm12` , which in theory should enable you to use any base image that you want). We are currently using a mixture of both options as we were unable to install everything with just neurodocker. The long-term goal is to switch to a newer (and slimmer) base image and to install everything what we need with only using the neurodocker flags.
4. In case you are working at the CIMH and you get SSL-Errors, reach out to us via e-mail.
