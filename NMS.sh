#!/bin/bash

# Define variables for target machines
TARGET1="remoteadmin@172.16.1.10"
TARGET2="remoteadmin@172.16.1.11"

# Function to execute commands on remote machines
execute_remote_command() {
    ssh $1 "$2"
}

# Target 1 configuration
execute_remote_command $TARGET1 "sudo hostnamectl set-hostname loghost"
execute_remote_command $TARGET1 "sudo sed -i 's/172.16.1.10\ttarget1/172.16.1.3\tloghost/' /etc/hosts"
execute_remote_command $TARGET1 "sudo sed -i 's/172.16.1.10\tloghost/172.16.1.4\twebhost/' /etc/hosts"
execute_remote_command $TARGET1 "sudo apt-get update && sudo apt-get install -y ufw"
execute_remote_command $TARGET1 "sudo ufw allow from 172.16.1.0/24 to any port 514 proto udp"
execute_remote_command $TARGET1 "sudo sed -i '/imudp/s/^#//' /etc/rsyslog.conf && sudo systemctl restart rsyslog"

# Target 2 configuration
execute_remote_command $TARGET2 "sudo hostnamectl set-hostname webhost"
execute_remote_command $TARGET2 "sudo sed -i 's/172.16.1.11\ttarget2/172.16.1.4\twebhost/' /etc/hosts"
execute_remote_command $TARGET2 "sudo sed -i 's/172.16.1.11\twebhost/172.16.1.3\tloghost/' /etc/hosts"
execute_remote_command $TARGET2 "sudo apt-get update && sudo apt-get install -y ufw apache2"
execute_remote_command $TARGET2 "sudo ufw allow 80/tcp"
execute_remote_command $TARGET2 "echo '*.* @loghost' | sudo tee -a /etc/rsyslog.conf"
execute_remote_command $TARGET2 "sudo systemctl restart rsyslog"

# Update NMS hosts file
echo -e "172.16.1.3\tloghost\n172.16.1.4\twebhost" | sudo tee -a /etc/hosts

# Check configurations
if firefox http://webhost &>/dev/null; then
    if ssh remoteadmin@loghost grep webhost /var/log/syslog &>/dev/null; then
        echo "Configuration update succeeded."
    else
        echo "Failed to retrieve logs from loghost for webhost."
    fi
else
    echo "Failed to retrieve default Apache page from webhost."
fi
