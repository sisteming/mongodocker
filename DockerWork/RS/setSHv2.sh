#!/bin/bash
# This runs on the mongos
HOST=$1
NSHARDS=$2
####################

rm /home/ubuntu/DockerWork/RS/sh.js
for i in `seq 1 $NSHARDS`;
do
	PORT=`/home/ubuntu/DockerWork/getPort.sh $i`
	echo "sh.addShard('rs$i/$HOST:$PORT')" >> /home/ubuntu/DockerWork/RS/sh.js
done
	echo "sh.status()" >> /home/ubuntu/DockerWork/RS/sh.js

#cat sh.js
sleep 10
mongo --host $HOST --port 27017 < /home/ubuntu/DockerWork/RS/sh.js
#sleep 10
