#!/bin/bash

# bash for updating my linux version

LINUX_VER=4.9.90
echo Linux version is updated to $LINUX_VER
mkdir -p ./tmp

wget -P ./tmp http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.90/linux-headers-4.9.90-040990_4.9.90-040990.201803250830_all.deb
wget -P ./tmp http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.90/linux-headers-4.9.90-040990-generic_4.9.90-040990.201803250830_amd64.deb
wget -P ./tmp http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.90/linux-image-4.9.90-040990-generic_4.9.90-040990.201803250830_amd64.deb

sudo dpkg -i ./tmp/linux-headers-$LINUX_VER-*.deb ./tmp/linux-image-$LINUX_VER-*.deb
