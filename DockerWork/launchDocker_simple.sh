#!/bin/bash
#SETUP DIRECTORY
#STOP All
echo "Stopping all containers..."
docker stop $(docker ps -q) > /dev/null

for i in {1..4}
do
	#Create directory (if not created)
	mkdir -p /space/data/db$i/db > /dev/null 

	#Run docker container
	docker run -p "3701$i":27017 -v "/space/data/db$i":/data mongodb mongod -f /etc/mongod.conf > /dev/null 2>&1 &
	
done
echo "Checking containers"
sleep 5
docker ps 
