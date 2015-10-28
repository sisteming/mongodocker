mongo --port $1 --eval "while(true) {print(JSON.stringify(db.serverStatus())); sleep($2*1000)}" >ss.log &
