# Utopia Server Core
This is the core repository that MUST be downloaded in order to create  
a proper environment for the utopia-server and its micro-services.

#### Table of Contents
- [Environment](environment)
- [Install](install)
- [Build & Run](build-run)

## Environment
### Create Root and Server CA certificates
These scripts will automatically create certificates and keys for local-host
```
# cd into root directory
bash ./create-root-certificates.sh
bash ./create-server-signing-ca.sh
``` 

## Build & Run
### Build docker image
This script will build an Ubuntu 20.04 LTS docker image and download the utopia server repository
```
chmod +x build-image.sh
./build-image.sh
```
### Start utopia-server (detached)
These commands will create a binary `utopia-server.exe` in the `server/Bin` directory  
This can be ran directly (from inside the container) using either ./server/Bin/utopia-server.exe or ./server/run-server.sh
After the project is built, we can run the web server by running the binary in the utopia-server directory
```
./start-instance.sh
```

## Testing
### Test the server inside the docker container
We can test the server by opening a new terminal, attaching to the container, and running `curl 'https://172.17.0.2:8080/helloworld'`
```
# in a new terminal
curl -v 'https://127.0.0.1:8080'
```
The command should output something like this in the very last line:
```
Testing.
```
