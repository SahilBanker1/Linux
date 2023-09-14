#!/bin/bash

# Get the hostname
hostname=$(hostname)

# Get the IP address and gateway IP using 'ip' command
ip_info=$(ip route | awk '/default/ {print $3}')

# Extract the IP address and gateway IP from the 'ip' output
ip_address=$(echo "$ip_info" | awk '{print $1}')
gateway_ip=$(echo "$ip_info" | awk '{print $2}')

# Display the system information
echo "Hostname: $hostname"
echo "IP Address: $ip_address"
echo "Gateway IP: $gateway_ip"
