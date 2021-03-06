#!/bin/bash

set -xe

locale-gen en_US.UTF-8

apt update
apt upgrade -y
apt install -y \
  apt-transport-https \
  curl

curl http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add -
echo "deb http://archive.raspberrypi.org/debian/ stretch main" > /etc/apt/sources.list.d/raspberrypi.list

curl https://download.docker.com/linux/raspbian/gpg | sudo apt-key add -
echo "deb [arch=armhf] https://download.docker.com/linux/raspbian stretch stable" > /etc/apt/sources.list.d/docker.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

apt update
apt install -y \
  --no-install-recommends \
  firmware-atheros \
  firmware-brcm80211 \
  firmware-libertas \
  firmware-ralink \
  firmware-realtek \
  raspberrypi-kernel \
  raspberrypi-bootloader \
  libraspberrypi0 \
  libraspberrypi-dev \
  libraspberrypi-bin \
  fake-hwclock \
  wpasupplicant \
  wireless-tools \
  ethtool \
  crda \
  bluetooth \
  pi-bluetooth \
  docker-ce

apt install -y \
  kubeadm \
  htop \
  iotop \
  iftop \
  vim \
  ntp \
  net-tools \
  openssh-server \
  bash-completion \
  haveged \
  ubuntu-release-upgrader-core \
  unattended-upgrades \
  dnsutils \
  screen

curl https://raw.githubusercontent.com/lurch/rpi-serial-console/master/rpi-serial-console -o /usr/local/bin/rpi-serial-console
chmod +x /usr/local/bin/rpi-serial-console

systemctl disable syslog
systemctl disable motd-news.service
systemctl disable motd-news.timer
systemctl enable docker
systemctl enable haveged
systemctl enable ntp

echo "
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp
" >> /etc/network/interfaces

sed -i "s/%sudo	ALL=(ALL:ALL) ALL/%sudo	ALL=(ALL:ALL) NOPASSWD:ALL/g" /etc/sudoers
sed -i "s/    HashKnownHosts yes/#   HashKnownHosts yes/g" /etc/ssh/ssh_config

rm /etc/update-motd.d/10-help-text
rm /etc/update-motd.d/50-motd-news
rm /etc/ssh/ssh_host_*

dpkg-reconfigure tzdata

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
