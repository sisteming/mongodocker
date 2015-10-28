#!/bin/bash


#CONFIGURATION 
NUM_MONGOD=16
TOTAL=4096
#MEMORY
#TOTAL MEMORY available
MONGOD_MEM=$(( $TOTAL - 1024 ))
MONGOD=$(( $MONGOD_MEM / $NUM_MONGOD ))
WT_CACHE=$(( $MONGOD / 2 ))
#-----CGROUPS----------
CGROUP=1
MEM=$MONGOD
CPU=512
MEMc=512
CPUc=512
MEMs=512
CPUs=512
#######################
PORTRANGE=4701
WORKDIR=/space/data2/data2RS
MONGODDIR=$WORKDIR/sh
MONGOCFG=$WORKDIR/configsvr
MONGOSDIR=$WORKDIR/mongos
MONGODCMD="gosu mongodb mongod -f /etc/mongod.conf --wiredTigerCacheSizeGB $WT_CACHE"

#MONGODCMD="gosu mongodb mongod -f /etc/mongod.conf"

MONGOSCMD='gosu mongodb mongos --configdb '
HOSTIP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

setup_kernel(){
	#ENSURE KERNEL SETTINGS ARE OK
	sudo sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
	sudo sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
	sudo sh -c "echo 0 > /proc/sys/vm/zone_reclaim_mode"
	sudo sh -c "echo never > /sys/kernel/mm/transparent_hugepage/defrag"
	sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
}

checknodes(){
	check=0
	check2=0
	PR=`echo $PORTRANGE + 1000 | bc`
	#MONGOD - RS
	for i in `seq 1 $NUM_MONGOD`;
        do	
		#RS1
		nc $HOSTIP $PORTRANGE$i -z
		up=$?
		if [ $up -ne  0 ]; then
			echo "$HOSTIP at $PORTRANGE$i is not up"
		fi
		check=`echo $up + $check | bc`	
		#RS2
		nc $HOSTIP $PR$i -z
		up2=$?
                if [ $up2 -ne 0 ]; then
			echo "$HOSTIP at $PR$i is not up"
                 fi
		check2=`echo $up2 + $check | bc`
	
	done


if [ $check -ne 0 ] || [ $check2 -ne 0 ]; then

	echo "Some nodes are not properly up and running"
	exit 1
fi
}
#CREATE DIR BASED ON TYPE
# type = mongod, configsvr, mongos

# num
createdir(){
	mkdir -p $WORKDIR 
	TYPE=$1
	NUM=$2
	#Create directory (if not created)
	if [ $TYPE = 'mongod' ]; then
	        mkdir -p $MONGODDIR$NUM/db > /dev/null
		#chown -R mongodb:mongodb $MONGODDIR$NUM
		chmod -R 777 $MONGODDIR$NUM
	elif [ $TYPE = 'configsvr' ]; then
		mkdir -p $MONGOCFG/{db,configdb} > /dev/null
		#chown -R mongodb:mongodb $MONGOCFG
		chmod -R 777 $MONGOCFG/
	else
		mkdir -p $MONGOSDIR/db > /dev/null
		chmod -R 777 $MONGOSDIR

	fi
	if [ $? -eq 0 ]; then
		echo "Directory created"
	else
		echo "Error creating new directories"
	fi
}

#RUN CONTAINER
# name, port, number, type, cfgsvr for mongos
runCont(){
	NAME=$1
 	echo "Running container with NAME $1 and PORT $2"
 	echo NAME $NAME	
	#getPort.sh with 2 parameters will get port from range 470..
	NUMBER=$3
	PORT=`./getPort.sh $NUMBER 1`
	echo PORT "$PORT"

	TYPE=$4	
	echo $4
	#TODO: REDIRECT OUTPUT TO /dev/null
	echo "$NAME $PORT $NUMBER $TYPE"
	if [ $TYPE = 'mongod' ]; then
		#MONGOD
                if [ $CGROUP -eq 0 ]; then
                        docker run --hostname $NAME --name $NAME -p $PORT:27017 -v $MONGODDIR$NUMBER:/data mongodb $MONGODCMD --replSet rs$i
                else
                        echo "Running with cgroups"
                        docker run --hostname $NAME --cpu-shares=$CPU --memory="$MEM"m  --name $NAME -p $PORT:27017 -v $MONGODDIR$NUMBER:/data mongodb $MONGODCMD --replSet rs$i
                fi
		
	elif [ $TYPE = 'configsvr' ]; then
		#MONGO CONFIG SERVER
                if [ $CGROUP -eq 0 ]; then
                        docker run --hostname $NAME --name $NAME -p $PORT:27019 -v $MONGOCFG:/data mongodb $MONGODCMD --configsvr
                else
                        docker run --hostname $NAME --cpu-shares=$CPUc --memory="$MEMc"m --name $NAME -p $PORT:27019 -v $MONGOCFG:/data mongodb $MONGODCMD --configsvr
                fi
	else 
		#MONGOS
                if [ $CGROUP -eq 0 ]; then
                        docker run --hostname $NAME --name $NAME -p $PORT:27017 -v $MONGOSDIR$i:/data mongodb $MONGOSCMD $5
                else
                        docker run --hostname $NAME --cpu-shares=$CPUs --memory="$MEMs"m --name $NAME -p $PORT:27017 -v $MONGOSDIR$i:/data mongodb $MONGOSCMD $5
                fi
        fi

	#ADDING HOSTNAME TO /ETC/HOSTS TO FIX ISSUES WITH REPLICA SET
         grep -i $NAME /etc/hosts
         sleep 5
	
	echo '**********************'

         check_hosts=`grep -i $NAME /etc/hosts`
        #IF NOT THERE, add it
         if [ $? -eq 1 ]; then
                 echo "NOT IN /ETC/hOSTS"
                 sudo sh -c "echo $HOSTIP $NAME >> /etc/hosts"
         fi
	
	echo '**********************'

	exit 0
}

stopContainers(){
	#STOP All
	echo "Stopping all containers..."
	docker stop $(docker ps -q)
	exit 0
}

clean(){
	docker rm $(docker ps -aq)
	exit 0
}

startRS(){
	#DATA NODES
	echo $NUM_MONGOD
	i=1
	for i in `seq 1 $NUM_MONGOD`;
	do
	#	createdir mongod $i
		echo $i
		#Run docker container
		echo "rs$i-srv2 $PORTRANGE$i $i 'mongod'"
		runCont "rs$i-srv2" "$PORTRANGE$i" "$i" 'mongod' > log/mongod$irs2.log 2>&1 &
		#docker run --name "rs$i-srv2" -p "$PORTRANGE$i":27017 -v "/space/data/db$i":/data mongodb mongod -f /etc/mongod.conf --replSet rs$i  &
		#> /dev/null 2>&1 &
	
	done
	exit 0
}

startConfigSvr(){
	#CONFIG SERVER
	runCont cfgsrv2 "$PORTRANGE"0 0 configsvr > log/cfgsvr.log 2>&1 &
	exit 0
}
	

startMongos(){
	#MONGOS
	echo $1 $2
	
	runCont mongos2 "$PORTRANGE"7 0 mongos $1:$2 > log/mongos.log 2>&1 & 
	exit 0
}

listContainers(){
	echo "Checking containers"
	sleep 5
	docker ps
}

createenv(){
	mkdir log >  /dev/null 2>&1
	sudo rm -rf $WORKDIR/sh*
	for i in `seq 1 $NUM_MONGOD`;
	do
		createdir mongod $i
	done
	createdir configsvr
	createdir mongos	
}

#MAIN SCRIPT

case "$1" in
init)	
	setup_kernel
	;;
setup)
	createenv
	;;
check)
	checknodes
	;;
startRS)
        startRS
        ;;
startConfigSvr)
        startConfigSvr 
        ;;
startMongos)
	startMongos $HOSTIP "$PORTRANGE"0
	;;
list)
	listContainers
	;;
stop)
	stopContainers
	;;
clean)
	clean
	;;
restart)
        $0 stop
        $0 startRS
	$0 startConfigSvr
	$0 startMongos
        ;;
*)      echo  'Usage: mongoDocker_RS1.sh {setup|startRS|startConfigSvr|startMongos|list|stop|restart}'
        exit 2
        ;;
esac
exit 0

