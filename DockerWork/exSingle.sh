#!/usr/bin/zsh
HOSTIP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

NUM_MONGOD=8
TOTAL=4096
#MEMORY
#TOTAL MEMORY available
MONGOD_MEM=$(( $TOTAL - 1024 ))
MONGOD=$(( $MONGOD_MEM / $NUM_MONGOD ))
WT_CACHE=$(( $MONGOD / 2 ))

WT_CACHE=512

/home/ubuntu/DockerWork/setKernel.sh
/home/ubuntu/DockerWork/mongoDocker_RS1.sh stop
/home/ubuntu/DockerWork/mongoDocker_RS1.sh clean
/home/ubuntu/DockerWork/mongoDocker_RS1.sh setup
#ls -la /space/data2*/*
/home/ubuntu/DockerWork/mongoDocker_RS1.sh startRS $MONGOD 512 $NUM_MONGOD

# ./mongoDocker_RS2.sh setup
# ./mongoDocker_RS2.sh startRS $NUM_MONGOD
#nc -z $HOSTIP 47016
#up=`echo $?`

#while [ $up -ne 0 ] 
#do

#	sleep 1
#	nc -z $HOSTIP 47016
#	up=`echo $?`
#done
# ./mongoDocker_RS1.sh check 

# ENABLE REPLICA SETS
# cd RS
/home/ubuntu/DockerWork/RS/setRSv2.sh $HOSTIP $HOSTIP $NUM_MONGOD
sh /home/ubuntu/DockerWork/RS/mongoRS.log
/home/ubuntu/DockerWork/RS/checkRSv2.sh $HOSTIP $NUM_MONGOD

# ENABLE SHARDING
#cd ..
/home/ubuntu/DockerWork/mongoDocker_RS1.sh startConfigSvr
sleep 10
#START MONGOS
/home/ubuntu/DockerWork/mongoDocker_RS1.sh startMongos

#sleep 30
#cd RS
/home/ubuntu/DockerWork/RS/setSHv2.sh $HOSTIP $NUM_MONGOD
#sleep 20
/home/ubuntu/DockerWork/RS/checkSHv2.sh $HOSTIP 27017


#./mongoDocker_RS3.sh setup
#ls -la /space/data2*/*
#./mongoDocker_RS3.sh startRS $NUM_MONGOD
