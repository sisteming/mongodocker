#!/bin/bash
cat sh.js
sleep 5
mongo --host 192.168.99.10 --port 37017 < sh.js
sleep 10
