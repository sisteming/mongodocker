#!/bin/bash
HOST=$1
PORT=$2
mongo --host $HOST --port $PORT < /home/ubuntu/DockerWork/RS/checksh.js
