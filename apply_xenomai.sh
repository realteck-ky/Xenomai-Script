#!/bin/bash

# create work-space
WORK_SPACE=$PWD/build_root
mkdir -p $WORK_SPACE
cd $WORK_SPACE

# set env value
LINUX_VAR=4.9.90 # make yourself
LINUX_PATH=$WORK_SPACE/linux-$LINUX_VAR
XENO_VAR=3.0.7 # make yourself
XENO_ROOT=$WORK_SPACE/xenomai-$XENO_VAR
IPIPE_VAR=4.9.90-x86-6 # better to use following linux version
IPIPE_ROOT=$WORK_SPACE/ipipe-core-$IPIPE_VAR.patch
#export CONCURRENCY_LEVEL=8 # core for building kernel (in make)

# get linux, xenomai & ipipe
wget https://xenomai.org/downloads/xenomai/stable/xenomai-$XENO_VAR.tar.bz2
tar xvf xenomai-$XENO_VAR.tar.bz2
wget http://www.kernel.org/pub/linux/kernel/v4.x/linux-$LINUX_VAR.tar.gz
tar xvf linux-$LINUX_VAR.tar.gz
wget https://xenomai.org/downloads/ipipe/v4.x/x86/ipipe-core-$IPIPE_VAR.patch

# Apply RT-preempt patch &xenomai & kernel build
cp -vi /boot/config-`uname -r` $LINUX_PATH/.config
cd $LINUX_PATH
$XENO_ROOT/scripts/prepare-kernel.sh --arch=x86_64\
 --linux=$LINUX_PATH --ipipe=$IPIPE_ROOT --verbose
make olddefconfig
make menuconfig
wait
CONCURRENCY_LEVEL=$(nproc) make-kpkg --rootcmd\
 fakeroot --initrd --arch=amd64 --append-to-version=-xenomai-$XENO_VAR\
 kernel-image kernel-headers
# ^ This shell file generate a deb file.

cd $WORK_SPACE
sudo dpkg -i linux-image-*.deb linux-headers-*.deb
#sudo update-initramfs -c -k $LINUX_VAR-xenomai-$XENO_VAR && sudo update-grub