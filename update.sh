#!/bin/bash

# Check if the script is run with superuser privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root using sudo."
  exit 1
fi

# Update package lists and upgrade installed packages
echo "Updating package lists..."
sudo apt update -y

echo "Upgrading installed packages..."
sudo apt upgrade -y

# Remove unnecessary packages and cleanup
echo "Removing unnecessary packages..."
sudo apt autoremove -y

echo "Cleaning up..."
sudo apt clean

echo "Software update completed successfully!"

