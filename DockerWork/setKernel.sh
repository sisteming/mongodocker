#!/bin/bash
# Disable THP
sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'
sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/defrag'
sudo sh -c "grep -q -F 'transparent_hugepage=never' /etc/default/grub || echo 'transparent_hugepage=never' >> /etc/default/grub"
sudo sh -c "echo 0 > /proc/sys/vm/zone_reclaim_mode"
sudo sysctl -w net.ipv4.tcp_keepalive_time=300 > /dev/null
sudo blockdev --setra 8 /dev/xvdb
sudo blockdev --setra 8 /dev/xvdc


