

# Running the applications locally with docker

- Install docker
- Run the `build_docker_image.sh` script to build a docker image
- Build the application with the `compile.sh` script if needed. This is needed if the reference code is modified or for example the eidas.xml or sp.properties file changes while setting up the environment variables
- Start the application with docker
- Start the docker containers
  `docker-compose up -d`    starts the application as a daemon
  `docker-compose logs -f`  tails the container logs
- Stop the docker containers
  `docker-compose down`     stops the containers and cleans up

Alternately
use the `deploy_and_run_docker.sh` and the `stop_docker_and_cleanup.sh` scripts which do the above

For debugging the JPDA ports will need to be exposed. Follow the instructions in the Dockerfile and rebuild the image
