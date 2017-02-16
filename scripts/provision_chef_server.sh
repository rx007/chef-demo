#!/bin/bash

# Make debconf use a frontend that expects no interactive input at al
export DEBIAN_FRONTEND=noninteractive

# Get IP address of eth1 because this is a Vagrant box
ipaddr=$(ifconfig eth1 | awk '/inet addr/{print substr($2,6)}')

# Enable Apt to fetch packages over HTTPS
apt-get install -y apt-transport-https ntp

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
apt-get install chef-server-core

# Attach the chef server to the existing backend-cluster
chef-server-ctl reconfigure

# Restart chef services
chef-server-ctl restart

# wait for services to be fully available
echo "Waiting for services..."
until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

# Create initial user
chef-server-ctl user-create admin Admin Admin admin@chef-server.local awesome --filename /vagrant/.chef/admin.pem

# Create initial org
chef-server-ctl org-create demo "Chef Server Demo" --association_user admin --filename /vagrant/.chef/demo-validator.pem
