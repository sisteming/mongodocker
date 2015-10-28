#!/bin/bash
HOST=$1
PORT=$2
NSHARDS=$3
#DB=socialite
DB=$4

mv getProfilingStatus.json getProfilingStatus.json.old

for i in `seq 1 $NSHARDS`;
do
	echo $i
	echo 'db.getProfilingStatus()' > getProfiling.json
	
	#APPLY RS CONFIG
	PORT=3701$i
	mongo $DB --host $HOST --port $PORT --eval "db.setProfilingLevel(2, 50000)" > enableProfiling$HOST$i.log
	mongo $DB --host $HOST --port $PORT < getProfiling.json >> getProfilingStatus.json
	sleep 1
done
