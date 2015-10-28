#!/usr/bin/zsh
NUM_MONGOD=4
TOTAL=9216
#MEMORY
#TOTAL MEMORY available
MONGOD_MEM=$(( $TOTAL - 1024 ))
MONGOD=$(( $MONGOD_MEM / $NUM_MONGOD ))
WT_CACHE=$(( $MONGOD / 2 ))

echo "Total memory is: $TOTAL"
echo "Based on $NUM_MONGOD shards"
echo "---"
echo "MONGOD memory...$MONGOD"
echo "WT cache...$WT_CACHE"
