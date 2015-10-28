#!/bin/bash
#SETUP DIRECTORY
#STOP All
echo "Stopping all containers..."
docker stop $(docker ps -q) > /dev/null
sh clean.sh
sleep 3
mkdir -p /space/data/cfg/{db,configdb} > /dev/null
mkdir -p /space/data/mongos/db > /dev/null
#chmod -R 777 /space/data

#DATA NODES
for i in {1..4}
do
	#Create directory (if not created)
	mkdir -p /space/data/db$i/db > /dev/null 

	#Run docker container
	docker run --name "rs$i-srv1" -p "3701$i":27017 -v "/space/data/db$i":/data mongodb mongod -f /etc/mongod.conf --replSet rs$i  &
	#> /dev/null 2>&1 &
	
done
i=0

#CONFIG SERVER
docker run --name cfgsrv1 -p 37010:27019 -v "/space/data/cfg":/data mongodb mongod -f /etc/mongod.conf --configsvr & 

echo "	docker run -p "3701$i":27017 -v "/space/data/cfg":/data mongodb mongod -f /etc/mongod.conf --configsvr "
	
sleep 5 
echo "	docker run -p "37017":27017 -v "/space/data/mongos":/data mongodb mongos --configdb localhost:37010 "

echo "Checking containers"
sleep 5
docker ps 
