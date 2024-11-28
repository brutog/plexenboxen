#!/bin/bash


# some packages
sudo apt install -y \
	cif-utils \
	nfs-common \
	apache2-utils \ # for htpasswd
	samba \
	git # just in case

# get the newest docker-compose
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# this adds "compose" as a verb to "docker"
sudo apt update
sudo apt install docker-compose docker-compose-plugin -y

# add user to docker group
sudo usermod -aG docker $USER

sudo mkdir -p /data
sudo chown -R $USER:$USER /data
mkdir -p /data/{download,tv,movies,music,books,audiobooks,comics}
mkdir -p /data/download/{sab,torrent}
mkdir -p /data/download/sab/{complete,incomplete}

# reboot is the quickest way for group changes to take effect
sudo reboot 
