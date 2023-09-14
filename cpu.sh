#!/bin/bash

# Get CPU activity using uptime
cpu_activity=$(uptime)

# Get free memory using free
free_memory=$(free -m | awk 'NR==2{print "Total: "$2" MB, Used: "$3" MB, Free: "$4" MB"}')

# Get free disk space using df
free_disk_space=$(df -h / | awk 'NR==2{print "Total: "$2", Used: "$3", Free: "$4}')

# Display system status information
echo "CPU Activity: $cpu_activity"
echo "Free Memory: $free_memory"
echo "Free Disk Space: $free_disk_space"
