# Install for Ubuntu Xenial

```
# Install virtualbox
wget http://download.virtualbox.org/virtualbox/5.1.4/virtualbox-5.1_5.1.4-110228~Ubuntu~xenial_amd64.deb
dpkg -i virtualbox-5.1_5.1.4-110228~Ubuntu~xenial_amd64.deb

# Install vagrant
wget https://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5_x86_64.deb
dpkg -i vagrant_1.8.5_x86_64.deb

# Install packages
sudo apt-get update
sudo apt-get install virtualbox-5.1 vagrant virtualbox-ext-pack

# Install vagrant plugins
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-hostmanager

# install ansible
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible

# install git and other tools
sudo apt-get install git vim

# Clone project
git clone https://github.com/jpitzo/slomedia-build.git

# Install galaxy plugins
ansible-galaxy install -r requirments.yml

# Unplug griffen!!

#Create media dir
sudo mkdir /slomedia

# Put all media in /slomedia

# Init vagrant 
vagrant up
```
