#!/bin/bash

# Make debconf use a frontend that expects no interactive input at al
export DEBIAN_FRONTEND=noninteractive

# Get IP address of eth1 because this is a Vagrant box
ipaddr=$(ifconfig eth1 | awk '/inet addr/{print substr($2,6)}')

# Enable Apt to fetch packages over HTTPS
apt-get install -y apt-transport-https curl tree zsh git ntp

# Update time
ntpdate -s time.nist.gov

# restart the service
service ntp restart

# Install the public key for Chef Software Inc
wget -qO - https://packages.chef.io/chef.asc | apt-key add -

# Create the Apt repository source file
echo "deb https://packages.chef.io/repos/apt/stable trusty main" > /etc/apt/sources.list.d/chef-stable.list

# Update the cache for the package repository
apt-get update

# Install the Chef Server package
apt-get install chefdk

# Add chef server IP to /etc/hosts
echo "192.168.33.10 chef-server.local chef-server" | tee -a /etc/hosts

# Change the vagrant user's shell to use zsh
chsh -s /bin/zsh vagrant
