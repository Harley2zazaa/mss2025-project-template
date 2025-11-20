cpu_usage=$(top -b -n 2 -d 0.01 | grep "Cpu(s)" | tail -1 | grep -E -o '[0-9]+\.[0-9]+ id' | grep -E -o '[0-9]+\.[0-9]+')
cpu_usage=$(bc <<< "100-$cpu_usage")
echo "Current CPU usage: $cpu_usage%"

mem_stats=$(free -m | awk 'NR==2{print $2, $3}')
total_mem=$(echo $mem_stats | awk '{print $1}')
used_mem=$(echo $mem_stats | awk '{print $2}')
mem_usage=$(echo "scale=2; 100 * $used_mem / $total_mem" | bc)
echo "Current Memory Usage: $mem_usage%"
total_mem=$(echo "scale=2; $total_mem / 1000" | bc)
used_mem=$(echo "scale=2; $used_mem / 1000" | bc)
echo "Memory Total: $total_mem G"
echo "Memory Used: $used_mem G"
