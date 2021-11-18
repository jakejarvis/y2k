#!/usr/bin/env bash

# WARNING: you probably shouldn't just run this! ;)

set -euxo pipefail

REPO_DIR=/root/y2k

#### install basic requirements ####
apt-get -y update
apt-get -y dist-upgrade
apt-get -y --no-install-recommends install \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    git \
    unzip

#### clone repository for scripts ####
git clone https://github.com/jakejarvis/y2k.git $REPO_DIR

#### install Docker from official repository ####
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
apt-get update
apt-get -y install \
    docker-ce \
    docker-ce-cli \
    containerd.io
docker version

#### docker fixes ####
## https://github.com/moby/moby/issues/4250
sed -i 's/\(GRUB_CMDLINE_LINUX="\)"/\1cgroup_enable=memory swapaccount=1"/' /etc/default/grub
update-grub
## enable `docker build --squash`
echo "{ \"experimental\": true }" > /etc/docker/daemon.json

#### install websocketd ####
## https://github.com/joewalnes/websocketd/releases
WEBSOCKETD_VERSION=0.4.1
wget -nv -P /tmp/ https://github.com/joewalnes/websocketd/releases/download/v${WEBSOCKETD_VERSION}/websocketd-${WEBSOCKETD_VERSION}-linux_amd64.zip
unzip /tmp/websocketd-${WEBSOCKETD_VERSION}-linux_amd64.zip websocketd -d /tmp
mv /tmp/websocketd /usr/local/bin/
chmod +x /usr/local/bin/websocketd
rm /tmp/websocketd-${WEBSOCKETD_VERSION}-linux_amd64.zip
websocketd --version

#### install cloudflared ####
## https://developers.cloudflare.com/argo-tunnel/downloads/
wget -nv -P /tmp/ https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb
dpkg -i /tmp/cloudflared-stable-linux-amd64.deb
rm /tmp/cloudflared-stable-linux-amd64.deb
cloudflared version

#### login to cloudflare ####
cp $REPO_DIR/host/.cloudflared/config.yml /etc/cloudflared/
cloudflared tunnel login
cloudflared service install
# move auto-downloaded certificate to a more sensible location
cp ~/.cloudflared/cert.pem /etc/cloudflared/
rm ~/.cloudflared/cert.pem

#### enable services ####
cp $REPO_DIR/host/example.service /lib/systemd/system/y2k.service
systemctl daemon-reload
systemctl enable y2k
systemctl enable cloudflared

#### build fresh docker image if ready ####
bash $REPO_DIR/build.sh || true

#### reboot ####
echo "Rebooting shortly..."
sleep 15
reboot 0
