# mongodocker
## Caveats
* This set of scripts has been tested on Ubuntu 12.04 / 14.04 and Docker 1.8 only
* The scripts are in shell script. In the future this should be converted to something smarter
* This was originally implemented to learn Docker and learn to build a MongoDB deployment from scratch using Docker
* I'm aware that this has a large room for improvement :)

## Main scripts

### mongoDocker_RS1.sh

This is the main script to configure, deploy and run MongoDB using Docker containers. 

Here we have several functions to simplify some of the operations during the deployment like the following:

* **setup_kernel()**: Setup some kernel parameters based on MongoDB best practices
* **checknodes()**: Check the current state of the MongoDB nodes for connectivity
* **runCont()**: Execute the docker container with a different set of options (memory, cgroups, directory, port)
* **stopContainers()**: Stop all running containers
* **startRS()**: Start all containers required for a ReplicaSet
* **startConfigSvr()**: Start container for the config Server
* **listContainers()**: List all running containers

These functions can be used as follows:
`./mongoDocker_RS1.sh stop`
`./mongoDocker_RS1.sh clean`
`./mongoDocker_RS1.sh setup`
`./mongoDocker_RS1.sh startRS`
`./mongoDocker_RS1.sh startConfigSvr`
`./mongoDocker_RS2.sh startRS`

This script is also repeated as **mongoDocker_RS2** and **mongoDocker_RS3** for each replica set, as they were running on different servers but also tested under a single server.


### mongodb.docker
Dockerfile used to build the MongoDB image
Please note the following:

* Based on the Ubuntu image
It will use the user mongodb and group mongodb
* Based on MongoDB 3.0.6
* It will use /data/db as data volume
* It takes the MongoDB configuration file from mongo_wt.conf (that needs to be on the same directory)
* The ports exposed are 27017 (mapped to a different port on the host) and 27019
* The command run is mongod -f /etc/mongod.conf so additional options can be added through the docker run command line

This file can be used to create a docker image with the following command:

`docker build -f mongodb.docker .`

PS. Please note that the file mongod_wt.conf and docker-entrypoint.sh need to be on the same directory as the dockerfile

### mongod_wt.conf
The configuration file used is the following:
`systemLog:
  destination: file
  path: "/data/db/mongod.log"
  logAppend: true
storage:
  engine: wiredTiger 
  wiredTiger:
    collectionConfig: 
      configString: 'type=file'
    indexConfig:
      configString: 'type=lsm'`
      
      
## Replica Sets and Sharding

Additional script to configure and deploy Replica Sets and sharding for the sharded cluster can be found in the RS/ directory.

Most of these accept parameters like the origin IP and target IP and the number of mongod used, so they can be used to scale according to our deployment.

### ReplicaSet setup script:
setRSv2.sh

### Sharding setup script:
setSHv2.sh
