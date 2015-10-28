#!/bin/bash
mongo --host 192.168.99.10 --port 37011 < rs1.js
sleep 10
mongo --host 192.168.99.10 --port 37012 < rs2.js
sleep 10
mongo --host 192.168.99.10 --port 37013 < rs3.js
sleep 10
mongo --host 192.168.99.10 --port 37014 < rs4.js
sleep 10
