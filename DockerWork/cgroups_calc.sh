#!/usr/bin/zsh
PROCESSES=4

# Getting the memory size in GB
  MS=$(cat /proc/meminfo | grep MemTotal)
 MS=${MS##*\:}
  MS=$(echo $MS | awk '{ print $1 }')
  MS=$(( $MS / 1024 ))

  # Getting the memory per shard
  MS=$(( $MS - 1 ))
  MS=$(( $MS / $PROCESSES ))
	
 echo $MS
  WT=$(( $MS / 2 ))
 echo "WT $WT"

  MS=$(( $MS * 1024 * 1024 ))
	
  echo $MS

  # Getting the number of processors
  local PC=$(cat /proc/cpuinfo | grep "^processor" | wc -l)

  # Getting the number of processors per shard
  local SC=$(( 1024 / $PROCESSES ))
  SC=${SC%.*}
  if [ "$SC" -lt 1 ]; then
    SC=1
  fi

  PC=$(( $PC - 1 ))

  echo $PC
