#!/bin/sh

# Creator:    VPR
# Created:    February 9th, 2022
# Updated:    February 9th, 2022

__docker_img="utopia-dev"

# Mounts local current working directory to /home/utopia in the container
docker run -ditp 8080:8080 "${__docker_img}" /home/utopia/server/Bin/server.exe
