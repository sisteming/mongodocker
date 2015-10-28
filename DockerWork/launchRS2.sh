#!/bin/bash
#SETUP DIRECTORY
#STOP All
echo "Stopping all containers..."
docker rm $(docker ps -a | grep -v Up | awk {'print $1'} | grep -v CON) 
#sh clean.sh
sleep 3
mkdir -p /space/data/rs/cfg/{db,configdb} > /dev/null
mkdir -p /space/data/rs/mongos/db > /dev/null
#chmod -R 777 /space/data

#DATA NODES
for i in {1..4}
do
	#Create directory (if not created)
	mkdir -p /space/data/rs/db$i/db > /dev/null 

	#Run docker container
	docker run --name "rs$i-srv2" -p "4701$i":27017 -v "/space/data/rs/db$i":/data mongodb mongod -f /etc/mongod.conf --replSet rs$i  &
	#> /dev/null 2>&1 &
	
done
i=0

#CONFIG SERVER
docker run --name cfgsrv2 -p 47010:27019 -v "/space/data/rs/cfg":/data mongodb mongod -f /etc/mongod.conf --configsvr & 

echo "	docker run -p "4701$i":27017 -v "/space/data/rs/cfg":/data mongodb mongod -f /etc/mongod.conf --configsvr "
	
sleep 5 
echo "	docker run -p "47017":27017 -v "/space/data/rs/mongos":/data mongodb mongos --configdb localhost:47010 "

echo "Checking containers"
sleep 5
docker ps 
