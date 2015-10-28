#!/bin/bash
ulimit -n 64000
ulimit -u 64000
echo 0 > /proc/sys/vm/zone_reclaim_mode
echo never > /sys/kernel/mm/transparent_hugepage/enabled

