#!/bin/bash

WORK_SPACE=$PWD/build_root
XENO_VAR=3.0.7
XENO_ROOT=$WORK_SPACE/xenomai-$XENO_VAR

sudo addgroup xenomai --gid 1234
sudo addgroup root xenomai
sudo usermod -a -G xenomai $USER

cd $XENO_ROOT
sudo ./configure --with-pic --with-core=cobalt --enable-smp --disable-tls --enable-dlopen-libs --disable-clock-monotonic-raw
sudo make -j`nproc`
sudo make install

echo '
### Xenomai
export XENOMAI_ROOT_DIR=/usr/xenomai
export XENOMAI_PATH=/usr/xenomai
export PATH=$PATH:$XENOMAI_PATH/bin:$XENOMAI_PATH/sbin
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$XENOMAI_PATH/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$XENOMAI_PATH/lib
export OROCOS_TARGET=xenomai
' >> ~/.xenomai_rc

echo 'source ~/.xenomai_rc' >> ~/.bashrc
source ~/.bashrc

echo "Xenomai test"
sudo -s
xeno test
# xeno latency

# sudo apt install rt-tests stress
# stress --cpu 4 --vm 4 --vm-bytes 1G --timeout 1m &
# sudo cyclictest -n -p 80 -t 10 -i 1000 -l 60000