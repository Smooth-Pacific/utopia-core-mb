#!/bin/sh

# Creator:    VPR
# Created:    February 9th, 2022
# Updated:    February 9th, 2022

# Guides used:
#     https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/#creating-ca-signed-certificates
#     https://blog.devolutions.net/2020/07/tutorial-how-to-generate-secure-self-signed-server-and-client-certificates-with-openssl/
#     https://nodeployfriday.com/posts/self-signed-cert/

set -e pipefail
set -e errexit
set -e nounset
set -e xtrace

PASSWORD="abcdefg" # DO NOT USE IN PRODUCTION
COUNTRY_NAME="US"
STATE="Texas"
LOCALE="Houston"
ORGANIZATION="smoothstack"
ORGANIZATION_UNIT="server-signing"
COMMON_NAME="127.0.0.1"
EMAIL="email@example.com"

mkdir -p certs/server_ca
cd certs/server_ca
mkdir -p certs csr private

touch index.txt
echo 01 > serial
echo 01 > crlnumber

# Generate server certificate private key
openssl genrsa -out private/${ORGANIZATION}_server.key 2048

# Generate server certificate signing request
echo "${COUNTRY_NAME}\n${STATE}\n${LOCALE}\n${ORGANIZATION}\n${ORGANIZATION_UNIT}\n${COMMON_NAME}\n${EMAIL}\n${ORGANIZATION}\n${ORGANIZATION}" | \
openssl req -new --config ../etc/server-ca.conf -key private/${ORGANIZATION}_server.key -passin pass:${PASSWORD} -out csr/${ORGANIZATION}_server.csr

# Create X509 certificate extension configuration file
cat > certs/${ORGANIZATION}_server.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
IP.2 = 192.168.0.196
EOF

# Generate Server Certificate
echo "${COUNTRY_NAME}\n${STATE}\n${LOCALE}\n${ORGANIZATION}\n${ORGANIZATION_UNIT}\n${COMMON_NAME}\n${EMAIL}\n${ORGANIZATION}\n" | \
openssl x509 -req -in csr/${ORGANIZATION}_server.csr -CA ../root_ca/certs/smoothstack_root.crt -CAkey ../root_ca/private/smoothstack_root.key -CAcreateserial \
-out certs/${ORGANIZATION}_server.crt -days 365 -sha256 -extfile certs/${ORGANIZATION}_server.ext

# Create pem bundle
cat certs/${ORGANIZATION}_server.crt ../root_ca/certs/${ORGANIZATION}_root.crt >  \
certs/ca-chain-bundle.cert.pem
