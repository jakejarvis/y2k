#!/usr/bin/env bash

# you probably shouldn't just run this! ;)

set -euxo pipefail

#### install basic requirements ####
apt-get -y update
apt-get -y dist-upgrade
apt-get -y --no-install-recommends install \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    curl \
    wget \
    unzip

#### install papertrail logging ####
wget -qO - --header="X-Papertrail-Token: CHANGEMECHANGEMECHANGEME" \
  https://papertrailapp.com/destinations/CHANGEME/setup.sh | bash

#### docker fixes ####
# sed -i 's/\(GRUB_CMDLINE_LINUX="\)"/\1cgroup_enable=memory swapaccount=1"/' /etc/default/grub
# update-grub

#### install Docker from official repository ####
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io

#### install websocketd ####
wget https://github.com/joewalnes/websocketd/releases/download/v0.3.1/websocketd-0.3.1-linux_amd64.zip
unzip websocketd-0.3.1-linux_amd64.zip
chmod +x websocketd
mv websocketd /usr/bin/

#### install cloudflared ####
wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb
dpkg -i cloudflared-stable-linux-amd64.deb
cloudflared update
cloudflared tunnel login
cloudflared service install
systemctl enable cloudflared
systemctl start cloudflared

#### clone repository ####
git clone https://github.com/jakejarvis/y2k.git /root/y2k

#### pull Docker image ####
docker login
docker pull jakejarvis/y2k:latest

#### enable & start service ####
cp /root/y2k/backend/server/example.service /lib/systemd/system/y2k.service
systemctl daemon-reload
systemctl enable y2k
systemctl start y2k
