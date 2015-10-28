#!/bin/bash
mongo --host 192.168.99.10 --port 37011 < /home/ubuntu/DockerWork/checkrs.js
sleep 1
mongo --host 192.168.99.10 --port 37012 < /home/ubuntu/DockerWork/checkrs.js 
sleep 1
mongo --host 192.168.99.10 --port 37013 < /home/ubuntu/DockerWork/checkrs.js
sleep 1
mongo --host 192.168.99.10 --port 37014 < /home/ubuntu/DockerWork/checkrs.js
sleep 1
