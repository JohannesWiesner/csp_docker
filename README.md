# Generating a docker image for the Complex Systems in Psychiatry Group (CSP)

## How to use the current docker image of the CSP group
The latest version can be found on [docker hub](https://hub.docker.com/r/johanneswiesner/csp/tags). You can pull the image by running `docker pull johanneswiesner/csp:1.1.0`

## How to build the docker image yourself
1. clone this repository to your machine
2. Run script to create the dockerfile: `generate_dockerfile.sh conda-environment.yml`
3. Build the image through `docker build -t imagename .`
4. Create container with image through `docker run -t -i --rm -p 8888:8888 --name containername imagename`

## Remarks on adjusting the image to your needs and contribute
1. Make sure you run generate_dockerfile.sh  and docker build on a regular basis (preferably after every single edit). This is tedious but in our experience, too many edits at once make it hard to debug what went wrong. The neurodocker image is still under heavy development which means that it is not guaranteed that every combination of arguments that you pass to docker run -i --rm repronim/neurodocker:latest generate docker will lead to a bug-free Dockerfile
2. The currently used base-image neurodebian:stretch-non-free is quite old and we would wish to switch to a newer version of neurodebian. However, with newer base images a lot of bugs happen and software like spm12 could not be installed using the neurodocker parameters. (This is also tightly related to 1., so make sure the image can be built and the container runs error free when using a different base image). 
3. At the moment the image relies on neurodebian, which offers packages we were unable to install with neurodocker in their repositories:
    a) [afni](http://neuro.debian.net/pkgs/afni.html#binary-pkg-afni) (version: '18.0.05+git24-gb25b21054~dfsg.1-1~nd90+1')
    b) [ants](http://neuro.debian.net/pkgs/ants.html#binary-pkg-ants) (base version: 2.1.0-5)
    c) [fsl](http://neuro.debian.net/pkgs/fsl.html#binary-pkg-fsl) (version: 5.0.9-5~nd90+1)
    d) [mricron](http://neuro.debian.net/pkgs/mricron.html#binary-pkg-mricron) (version: 0.20140804.1~dfsg.1-1~nd80+1+nd90+1)
At some point it would definitely resolve dependencies, if we could install these through neurodocker and choose a newer (and slimmer) base image!
