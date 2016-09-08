# Install for Ubuntu Xenial

## Easy way

This script still may be a little buggy as installing vbox extensions doesn't always go smoothly

```
./setup.sh
```

You will now have a folder /data/media on the host machine to put your media in.  Use the included demux.py script
to demux videos in to separate audio and video tracks

## Hard way

```
# Install virtualbox
wget http://download.virtualbox.org/virtualbox/5.1.4/virtualbox-5.1_5.1.4-110228~Ubuntu~xenial_amd64.deb
dpkg -i virtualbox-5.1_5.1.4-110228~Ubuntu~xenial_amd64.deb

wget http://download.virtualbox.org/virtualbox/5.1.4/Oracle_VM_VirtualBox_Extension_Pack-5.1.4-110228.vbox-extpack
vboxmanage extpack install --replace ./Oracle_VM_VirtualBox_Extension_Pack-5.1.4-110228.vbox-extpack

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

#Create media dir
sudo mkdir /slomedia

# Put all media in /slomedia and run demux

# Init vagrant 
vagrant up
```

# Troubleshooting

1. First try unplugging and replugging in the griffin controller.  Occasionally virtualbox will not attach it to the correct host on startup
2. Run `vagrant provision` in the folder where the code resides
3. Run `vagrant halt`, `vagrant destory` and `vagrant up` as a scortched earth approach to the problem
