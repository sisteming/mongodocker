#!/bin/bash
HOSTL=$1
HOSTR=$2
NSHARDS=$3
rm /home/ubuntu/DockerWork/RS/mongoRS3.log

for i in `seq 1 $NSHARDS`;
do
	RP=`/home/ubuntu/DockerWork/getPort.sh $i 1 1`
	PORT=`/home/ubuntu/DockerWork/getPort.sh $i`
	#BUILD FILE FOR MONGO RS setup
	echo "rs.add('$HOSTR:$RP')" > rs3-$i.js
	#echo "cfg = rs.conf()" >> rs3-$i.js
	#echo "cfg.members[0].host = '$HOSTL:$PORT'" >> rs3-$i.js
	#echo "rs.reconfig(cfg,{force:true})" >> rs3-$i.js
	echo "rs.status()" >> rs3-$i.js

	#APPLY RS CONFIG
	#PORT=3701$i
	PORT=`/home/ubuntu/DockerWork/getPort.sh $i`
	echo "Config for RS $i"

	#cat rs$i.js
	#sleep 10
	echo "mongo --host $HOSTL --port $PORT < rs3-$i.js" >> /home/ubuntu/DockerWork/RS/mongoRS3.log
	#mongo --host $HOSTL --port $PORT < rs$i.js
	echo "sleep 1" >> mongoRS3.log
	#mongo --port $PORT --host $HOSTL --eval="db.isMaster().hosts"
done
sleep 10
sh /home/ubuntu/DockerWork/RS/mongoRS3.log
