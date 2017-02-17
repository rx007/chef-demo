# Chef Demo

This will provision both Chef server and a chef workstation using Vagrant and Virtualbox.

# Requirements

Download and install the following packages:

 - `virtualbox` - https://www.virtualbox.org/wiki/Downloads
 - `vagrant` - https://www.vagrantup.com/downloads.html
 - `chefdk` - https://downloads.chef.io/chefdk


# Installation

Clone this repo
```
git clone git@github.com:rx007/chef-demo.git
```

Bring up the vms
```
cd chef-demo
vagrant up
```

Here are the machines
<table>
  <tr>
    <th>vm</th>
    <th>specs</th>
    <th>hostname</th>
    <th>ip address</th>
  </tr>
  <tr>
    <td>chefserver</td>
    <td>2 vCPU, 2048</td>
    <td><tt>chef-server.local</tt></td>
    <td>192.168.33.10</td>
  </tr>
  <tr>
    <td>chefworks</td>
    <td>1 vCPU, 512</td>
    <td><tt>chef-workstation.local</tt></td>
    <td>192.168.33.11</td>
  </tr>
</table>

Login to your workstation
```
vagrant ssh chefworks
```

Chef-repo has been pre-generated and is stored inside `/vagrant` as well as knife configuration `knife.rb` and your client key `admin.pem`
```
cd /vagrant
knife ssl fetch
```

Knife configuration
```
# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "admin"
client_key               "#{current_dir}/admin.pem"
chef_server_url          "https://chef-server.local/organizations/demo"
cookbook_path            ["#{current_dir}/../cookbooks"]
```

Bootstrap your own workstation as a node to chef server
```
knife bootstrap 192.168.33.11 --sudo --identity-file /vagrant/.vagrant/machines/chefworks/virtualbox/private_key --node-name chef-workstation.local
```

Check your nodes
```
knife node list
```

Upload your cookbook to chef server
```
knife cookbook upload COOKBOOKNAME
```

Execute chef-client on your node
```
sudo chef-client
```

# Contributors

rx007

## License

This is licensed under Apache 2.0
