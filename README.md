# Generating a docker image for the Complex Systems in Psychiatry Group (CSP)
## How to use the current docker image of the CSP group
The latest version can be found on [docker hub](https://hub.docker.com/r/johanneswiesner/csp/tags). You can pull the image by running `docker pull johanneswiesner/csp:1.0.0`
## How to contribute
1. Make your changes to `generate_dockerfile.sh`
2. Run `generate_dockerfile.sh`, which will use `neurodocker` to create a `Dockerfile` with your changes
3. Create a docker image from the Dockerfile by running ```docker build -t johanneswiesner/csp:X.X.X .``` (where X.X.X should replaced with a new version number)
4. Push this new image to docker hub
5. Commit your changes on GitHub