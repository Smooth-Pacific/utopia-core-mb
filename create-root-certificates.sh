#!/bin/sh

# Creator:    VPR
# Created:    February 9th, 2022
# Updated:    February 9th, 2022

set -e pipefail
set -e errexit
set -e nounset
set -e xtrace

PASSWORD="abcdefg" # DO NOT USE IN PRODUCTION
COUNTRY_NAME="US"
STATE="STATE"
LOCALE="CITY"
ORGANIZATION="smoothstack"
ORGANIZATION_UNIT="utopia-root"
COMMON_NAME="SS" # Smooth Stack
EMAIL="email@example.com"

mkdir -p certs/root_ca
(
    cd certs/root_ca
    mkdir -p certs private

    # Generate private key
    openssl genrsa -des3 -passout pass:${PASSWORD} -out private/${ORGANIZATION}_root.key 2048

    # Generate root certificate
    echo "${COUNTRY_NAME}\n${STATE}\n${LOCALE}\n${ORGANIZATION}\n${ORGANIZATION_UNIT}\n${COMMON_NAME}\n${EMAIL}\n" | \
    openssl req -x509 -new -nodes -config ../etc/root-ca.conf -key private/${ORGANIZATION}_root.key -sha256 -passin pass:${PASSWORD} -days 365 -out certs/${ORGANIZATION}_root.crt

    ## Uncomment if testing on home machine
    # Add newly created CA to list of CA's
    #cp root-CA.crt /usr/local/share/ca-certificates

    # Update certs
    #sudo update-ca-certificates
)
