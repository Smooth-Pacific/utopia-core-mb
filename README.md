# Utopia Server Core
This is the core repository that MUST be downloaded in order to create  
a proper environment for the utopia-server and its micro-services.

#### Table of Contents

## Environment
## Install
## Build & Run

## Environment
### Create Root and Server CA certificates
```
# cd into root directory
bash ./create-root-certificates.sh
bash ./create-server-signing-ca.sh
``` 

These scripts will automatically create certificates and keys for localhost
### Build docker image
```
sh build_img.sh Dockerfile
```
This script will build an Ubuntu 20.04 LTS docker image and install the client root certificate

<!-- Spin up and attach to docker container-->
<!--Once the docker image is created, we can spin up and attach to the container as user utopia.-->
<!--```-->
<!--sh spinup.sh && sh attach.sh-->
<!--```-->
<!--The `attach.sh` script can be used separately to attach to the container in a new terminal-->

### Check that the Root Certificate was installed successfully
Once we are attached to the container, we now need to check that the root certificate was installed successfully. If the root certificate has been validated we can exit the container via the command `exit`
```
awk -v cmd='openssl x509 -noout -subject' '/BEGIN/{close(cmd)};{print | cmd}' < /etc/pki/ca-trust/source/anchors/smoothstack_root.crt | grep smoothstack

exit
```
## Build and Run the web server
### Build project inside docker container
We can now build the utopia server, but first we attach to the container.
```
sh attach.sh
```
Once attached, we can now navigate to the project folder and build.
```
git clone --recursive https://www.github.com/Smooth-Pacific/utopia-server-mb.git ~/utopia
cd ~/utopia-server-mb
make
```
These commands will create a binary `utopia-server.exe` in the `bin` directory

### Run server binary
After the project is built, we can run the web server by running the binary in the utopia-server directory
```
~/utopia-server-mb/Bin/utopia-server.exe
```

## Testing
### Test the server inside the docker container
We can test the server by opening a new terminal, attaching to the container, and running `curl 'https://172.17.0.2:8080/helloworld'`
```
# in a new terminal
sh attach.sh
curl -v 'https://127.0.0.1:8080/hello'
```
The command should output something like this in the very last line:
```
Testing.
```

<!--Adding Root Certificate to client machines-->
<!--In order to add the Root Certificate to a client (in thise case an ubuntu system), we must first copy the `smoothstack_client.crt` file that we created to the client system.-->
<!--We can do this by navigating to the project root directory and run:-->
<!--```-->
<!--sudo cp ./certs/smoothstack_client.crt /usr/local/share/ca-certificates/smoothstack_client.crt-->
<!--sudo update-ca-certificates-->
<!--```-->

<!--Once the certificate is added, we need to check if it was installed successfully by running:-->
<!--```-->
<!--awk -v cmd='openssl x509 -noout -subject' '/BEGIN/{close(cmd)};{print | cmd}' < /etc/ssl/certs/ca-certificates.crt | grep smoothstack-->
<!--```-->

<!--The output of the previous command should look something like:-->
<!--```-->
<!--subject=C = US, ST = Texas.test, L = Houston.test, O = smoothstack.test, OU = smoothstack, CN = smoothstack, emailAddress = email@example.com-->
<!--```-->
<!--We can now test the server by running:-->
<!--```-->
<!--curl -v 'https://127.0.0.1:8080/helloworld'-->
<!--```-->
<!--Expected output:-->
<!--```-->
<!--Testing.-->
<!--```-->
