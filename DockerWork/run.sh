./mongoDocker_RS1.sh stop
./mongoDocker_RS1.sh clean
sudo rm -rf /space/data2/*
./mongoDocker_RS1.sh setup
./mongoDocker_RS1.sh startRS
./mongoDocker_RS1.sh startConfigSvr
./mongoDocker_RS2.sh startRS
cd RS
sleep 10
echo "Setting replica set + sharding"
./setRS.sh
sleep 5
cd ..
./mongoDocker_RS1.sh startMongos
sleep 5
cd RS
./setSH.sh
