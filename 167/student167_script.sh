#!/bin/bash

cpu_idle=$(top -b -n 2 -d 0.01 | grep 'Cpu(s)' | tail -1 | grep -E -o '[0-9]+\.[0-9]+ id' | grep -E -o '[0-9]+\.[0-9]+')
cpu_usage=$(bc <<< "100-$cpu_idle")

memory=$(free -m | awk 'NR==2{print $2, $3 }')
memory_total=$(echo $memory | awk '{print $1}')
memory_used=$(echo $memory | awk '{print $2}')
memory_usage=$(bc <<< "scale=2; 100 * $memory_used/$memory_total")
echo $memory_usage
df -h | grep '/dev/sda[0-9]' | awk '{print , }' | grep -o -E '[0-9]+(.[0-9]+)?' | awk 'NR==1{print }'
