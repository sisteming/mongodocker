#!/bin/bash
HOST=$1
NSHARDS=$2

for i in `seq 1 $NSHARDS`;
do
	PORT=`/home/ubuntu/DockerWork/getPort.sh $i`
	mongo --host $HOST --port $PORT < /home/ubuntu/DockerWork/RS/checkrs.js > /home/ubuntu/DockerWork/RS/checkrs$i.log
	if [ $? -ne 0 ]; then
		echo "Error connecting to node $i at port $PORT"
	fi 
	sleep 1
done
