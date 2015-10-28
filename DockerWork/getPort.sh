#!/bin/bash
NUMBER=$1
if [ "$#" -eq 1 ]; then
	BASEPORT=370
elif [ "$#" -eq 2 ]; then
        BASEPORT=470
else
	BASEPORT=570
fi
if [ "$NUMBER" -le 9 ]; then
	PORT=$BASEPORT'0'$NUMBER
	echo $PORT
elif  [ "$NUMBER" -ge 9 ] ; then
	if  [ "$NUMBER" -le 99 ] ; then
		PORT=$BASEPORT$NUMBER
		echo $PORT
#		echo NUMBER is $NUMBER --- PORT will be $PORT
	else
		echo NUMBER $NUMBER is out of range.
	fi
fi
