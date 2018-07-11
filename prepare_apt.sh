#!/bin/bash

# install necessary app
sudo apt install gcc make -y
sudo apt install git build-essential kernel-package fakeroot\
                 libncurses5-dev libssl-dev ccache -y
# make a break fast
sudo apt update
sudo apt upgrade -y