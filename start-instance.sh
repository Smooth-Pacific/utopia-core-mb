#!/bin/sh

# Creator:    VPR
# Created:    February 9th, 2022
# Updated:    March 1st, 2022

DOCKER_IMAGE="utopia-dev"
ENV_FILE="environment.env"

ENV_PROTOCOL=1 # Set this to 0 for IPV4 and 1 for IPV6
ENV_PORT=8080  # Port to be exposed and bound to by server

if [ ${ENV_PROTOCOL} -eq 1 ]:
then
    echo "Launching with IPV6 enabled"
    # Mounts local current working directory to /home/utopia in the container
    docker run -ditp "${ENV_PORT}:${ENV_PORT}" --network mynetv6-1 --env-file ${ENV_FILE} --env "PORT=${ENV_PORT}" --env "INTERNET_PROTOCOL=${ENV_IPV6}" "${DOCKER_IMAGE}" /home/utopia/server/Bin/server.exe
else
    echo "Launching with IPV4 enabled"
    # Mounts local current working directory to /home/utopia in the container
    docker run -ditp "${ENV_PORT}:${ENV_PORT}" --env-file ${ENV_FILE} --env "PORT=${ENV_PORT}" --env "INTERNET_PROTOCOL=${ENV_IPV6}" "${DOCKER_IMAGE}" /home/utopia/server/Bin/server.exe
fi
