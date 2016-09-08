#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHTRED='\033[1;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

for (( ; ; ))
do
   read -p "Where would you like to install to?  Defaults to home dir [$HOME]: " INSTALL_DIR
   INSTALL_DIR=${INSTALL_DIR:-$HOME}
   if [ -d "$INSTALL_DIR" ]; then
        printf "${GREEN}Got it! I'll do it, I guess..${NC}\n"
        break              #Abandon the loop.
   else
      printf "${LIGHTRED}Nope, not a directory${NC}"
   fi
done


# Git Install
sudo apt-get install -y git vim

vbox_install () {
    if hash vboxmanage 2>/dev/null; then
        printf "${GREEN}VirtualBox is already installed skipping${NC}\n"
    else
        printf "${PURPLE}Installing VirtualBox...${NC}\n"
        echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" | sudo tee --append /etc/apt/sources.list
        wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
        
        sudo apt-get update
        sudo apt-get install -y virtualbox-5.1
        
        printf "${PURPLE}Installing Virtualbox extensions...${NC}\n"
        wget -P /tmp http://download.virtualbox.org/virtualbox/5.1.4/Oracle_VM_VirtualBox_Extension_Pack-5.1.4-110228.vbox-extpack
        vboxmanage extpack install --replace /tmp/Oracle_VM_VirtualBox_Extension_Pack-5.1.4-110228.vbox-extpack
    fi
}

ansible_install () {
    if hash ansible-playbook 2>/dev/null; then
        printf "${GREEN}Ansible is already installed. Skipping${NC}\n"
    else
        printf "${PURPLE}Installing ansible...${NC}\n"
        sudo apt-get install -y software-properties-common
        sudo apt-add-repository ppa:ansible/ansible
        sudo apt-get update
        sudo apt-get install -y ansible
    fi
}

vagrant_install () {
    if hash vagrant 2>/dev/null; then
        printf "${GREEN}Vagrant is already installed skipping${NC}\n"
    else
        printf "${PURPLE}Installing vagrant...${NC}\n"
        wget -P /tmp https://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5_x86_64.deb
        sudo dpkg -i /tmp/vagrant_1.8.5_x86_64.deb
        rm -f /tmp/vagrant_1.8.5_x86_64.deb
        
        printf "${PURPLE}Installing vagrant plugins...${NC}\n"
        vagrant plugin install vagrant-cachier
        vagrant plugin install vagrant-hostmanager
    fi
}

vbox_install
ansible_install
vagrant_install

printf "${PURPLE}Cloning git repo...${NC}\n"

if [ -d "$INSTALL_DIR/slomedia-build" ]; then
    printf "${LIGHTRED}Oh Snap!  The project is already checked out.${NC}\n"
else
    git clone https://github.com/jpitzo/slomedia-build.git $INSTALL_DIR/slomedia-build
fi

printf "${PURPLE}Check if media dir exists...${NC}\n"

MEDIA_DIR="/data/media"
if [[ -d $MEDIA_DIR ]]; then
    printf "${GREEN}Media directory already exists.${NC}\n"
elif [[ -f $MEDIA_DIR ]]; then
    printf "${LIGHTRED}Oh Snap! $MEDIA_DIR is a file?  Don't do that.${NC}\n"
else
    printf "${PURPLE}Creating media dir...${NC}\n"
    sudo mkdir $MEDIA_DIR
    sudo chown -R $USER:$USER $MEDIA_DIR
fi

read -p "Do you want to run vagrant now? [Y/n]: " VRUN
VRUN=${VRUN:-Y}

if [[ $VRUN =~ ^[Yy]$ ]]
then
    cd $INSTALL_DIR/slomedia-build
    vagrant up
fi
