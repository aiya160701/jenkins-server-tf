#!/bin/bash

# Update package list
sudo apt-get update -y

# Install OpenJDK 17 (both JDK and JRE)
sudo apt install -y openjdk-17-jdk openjdk-17-jre

# Create the jenkins user with a home directory, setting the default shell
sudo useradd -m -s /bin/bash jenkins

# Switch to the jenkins user to set up SSH configuration
sudo -u jenkins bash 
#Create the .ssh directory in the jenkins user's home and set permissions
mkdir -p /home/jenkins/.ssh

# Create and add a public SSH key to the authorized_keys file (with a terraform.tfvars variable)
echo "${jenkins_public_key}" > /home/jenkins/.ssh/authorized_keys

chmod 700 /home/jenkins/.ssh
chmod 600 /home/jenkins/.ssh/authorized_keys

# Set ownership of the .ssh directory to the jenkins user
sudo chown -R jenkins:jenkins /home/jenkins/.ssh






