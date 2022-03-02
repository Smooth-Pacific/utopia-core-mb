#!/bin/sh

# Creator:    VPR
# Created:    February 9th, 2022
# Updated:    February 9th, 2022

# Guides used:
#     https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/#creating-ca-signed-certificates
#     https://blog.devolutions.net/2020/07/tutorial-how-to-generate-secure-self-signed-server-and-client-certificates-with-openssl/
#     https://nodeployfriday.com/posts/self-signed-cert/
#     https://stackoverflow.com/questions/10782826/digital-signature-for-a-file-using-openssl

set -e pipefail
set -e errexit
set -e nounset
set -e xtrace

# Create necessary folders
mkdir -p certs/document_ca csr private
( 
    cd certs/document_ca
    touch index.txt
    echo 01 > serial
    echo 01 > crlnumber
)

PASSWORD="abcdefg" # DO NOT USE IN PRODUCTION
COUNTRY_NAME="US"
STATE="Texas"
LOCALE="Houston"
ORGANIZATION="smoothstack"
ORGANIZATION_UNIT="document-signing"
COMMON_NAME="localhost"
EMAIL="email@example.com"

# generate document Certificate Private key
openssl genrsa -out private/${ORGANIZATION}_document.key 2048

# generate document Certificate Signing Request
openssl req -new -config ../etc/document-ca.conf -key private/${ORGANIZATION}_document.key -out csr/${ORGANIZATION}_document.csr

# generate document certificate
openssl x509 -req -in csr/${ORGANIZATION}_document.csr -CA ../root_ca/certs/smoothstack_root.crt -CAkey ../root_ca/private/smoothstack_root.key -CAcreateserial \
-out certs/${ORGANIZATION}_document.crt -passin pass:${PASSWORD} -days 365 -sha256

# create pem bundle
cat certs/${ORGANIZATION}_document.crt ../root_ca/certs/${ORGANIZATION}_root.crt >  \
certs/ca-chain-bundle.cert.pem
