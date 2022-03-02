#!/bin/sh

# Creator:    VPR
# Created:    February 9th, 2022
# Updated:    February 9th, 2022

set -e pipefail
set -e errexit
set -e nounset
set -e xtrace

__docker_file="Dockerfile"

# Builds docker image using root Dockerfile
docker build -f "${__docker_file}" -t utopia-dev .
