#!/bin/bash
HOSTL=$1
HOSTR=$2
NSHARDS=$3
rm /home/ubuntu/DockerWork/RS/mongoRS.log

for i in `seq 1 $NSHARDS`;
do
	RP=`/home/ubuntu/DockerWork/getPort.sh $i 1`
	PORT=`/home/ubuntu/DockerWork/getPort.sh $i`
	#BUILD FILE FOR MONGO RS setup
	echo "rs.initiate()" > rs$i.js	
	echo "rs.add('$HOSTR:$RP')" >> rs$i.js
	echo "cfg = rs.conf()" >> rs$i.js
	echo "cfg.members[0].host = '$HOSTL:$PORT'" >> rs$i.js
	echo "rs.reconfig(cfg,{force:true})" >> rs$i.js
	echo "rs.status()" >> rs$i.js

#	echo "rs.initiate()" > rs$i.js	
#       	echo "cfg = rs.conf()" >> rs$i.js
#       	echo "cfg.members[0].host = '$HOSTL:$PORT'" >> rs$i.js
#       	echo "rs.reconfig(cfg,{force:true})" >> rs$i.js
	
#       	echo "cfg = rs.conf()" >> rs$i.js
#	echo "rs.add('$HOSTR:$RP')" >> rs$i.js
#	echo "rs.reconfig(cfg,{force:true})" >> rs$i.js
	
#       echo "rs.status()" >> rs$i.js


	#APPLY RS CONFIG
	#PORT=3701$i
	PORT=`/home/ubuntu/DockerWork/getPort.sh $i`
	echo "Config for RS $i"

	#cat rs$i.js
	#sleep 10
	echo "mongo --host $HOSTL --port $PORT < rs$i.js" >> /home/ubuntu/DockerWork/RS/mongoRS.log
	#mongo --host $HOSTL --port $PORT < rs$i.js
	echo "sleep 1" >> /home/ubuntu/DockerWork/RS/mongoRS.log
	#mongo --port $PORT --host $HOSTL --eval="db.isMaster().hosts"
done
sleep 50
sh mongoRS.log
