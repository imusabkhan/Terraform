#!/bin/bash

# Update package lists for available upgrades
sudo apt-get update -y

# Install Docker and Docker dependencies
sudo apt install docker.io -y

# Start Docker service using systemd
sudo systemctl start docker

# Add the current user to the Docker group
sudo usermod -aG docker $(whoami)

# Pull the DVWA image
sudo docker pull vulnerables/web-dvwa

# Port Forwarding from Local Machine to EC2 Instance on Port 80
sudo docker run -d -p 80:80 vulnerables/web-dvwa
