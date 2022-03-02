#!/bin/sh

# Creator:    VPR
# Created:    February 9th, 2022
# Updated:    March 1st, 2022

ENV_FILE="environment.env"
DOCKER_IMAGE="utopia-dev"

ENV_PORT=8080  # Port to be exposed and bound to by server
ENV_IPV6=0     # Set this to 1 to enable IPV6

if [ ${ENV_IPV6} -eq 1 ]:
then
    echo "Launching with IPV6 enabled"
    # Mounts local current working directory to /home/utopia in the container
    docker run -ditp "${ENV_PORT}:${ENV_PORT}" --ipv6 --env-file ${ENV_FILE} --env "PORT=${ENV_PORT}" --env "IPV6=${ENV_IPV6}" "${DOCKER_IMAGE}" /home/utopia/server/Bin/server.exe
else
    echo "Launching with IPV4 enabled"
    # Mounts local current working directory to /home/utopia in the container
    docker run -ditp "${ENV_PORT}:${ENV_PORT}" --env-file ${ENV_FILE} --env "PORT=${ENV_PORT}" --env "IPV6=${ENV_IPV6}" "${DOCKER_IMAGE}" /home/utopia/server/Bin/server.exe
fi
