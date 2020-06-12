#!/usr/bin/env bash

# WARNING: you probably shouldn't just run this! ;)

set -euxo pipefail

#### install basic requirements ####
apt-get -y update
apt-get -y dist-upgrade
apt-get -y --no-install-recommends install \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    unzip

#### install papertrail logging ####
wget -qO - --header="X-Papertrail-Token: CHANGEMECHANGEMECHANGEME" \
  https://papertrailapp.com/destinations/CHANGEME/setup.sh | bash

#### install Docker from official repository ####
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
docker version

#### docker fixes ####
## https://github.com/moby/moby/issues/4250
# sed -i 's/\(GRUB_CMDLINE_LINUX="\)"/\1cgroup_enable=memory swapaccount=1"/' /etc/default/grub
# update-grub

#### install websocketd ####
## https://github.com/joewalnes/websocketd/releases
WEBSOCKETD_VERSION=0.3.1
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
cloudflared service install
systemctl enable cloudflared
systemctl start cloudflared

#### login to cloudflare ####
cloudflared tunnel login

#### install Google Cloud Registry credential helper ####
## https://cloud.google.com/container-registry/docs/advanced-authentication#standalone-helper
## https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases
GCR_HELPER_VERSION=2.0.1
curl -fsSL https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${GCR_HELPER_VERSION}/docker-credential-gcr_linux_amd64-${GCR_HELPER_VERSION}.tar.gz | tar xz --to-stdout ./docker-credential-gcr > /usr/local/bin/docker-credential-gcr
chmod +x /usr/local/bin/docker-credential-gcr
docker-credential-gcr version

#### login to GCR ####
docker-credential-gcr gcr-login
docker-credential-gcr configure-docker

#### pull OS container ####
docker pull gcr.io/jakejarvis/y2k:latest

#### clone repository for scripts ####
git clone https://github.com/jakejarvis/y2k.git /root/y2k

#### enable & start service ####
cp /root/y2k/backend/server/example.service /lib/systemd/system/y2k.service
systemctl daemon-reload
systemctl enable y2k
systemctl start y2k