#!/bin/bash
# Author: DennisLiu16

# Version: 1.1

# For any server, the best way to get this script is git clone
# sudo apt install git 
# git clone https://github.com/DennisLiu16/pkg_installation_script

# Todo list
#   - func:getopts

# function define
function NL() {
    # new line
    echo " "
}

function installation_info() {
    NL
    echo "$1 is installing"
}

function installation_end() {
    echo "$1 installation finished"
    NL
}

# TODO: get params

# create a tmp dir
mkdir ./pkg_tmp
cd ./pkg_tmp

# update 
sudo apt update -y
sudo apt upgrade -y

# install ubuntu build essential tool
# dpkg-dev
# g++
# gcc
# libc6-dev
# make
installation_info "build-essential"
sudo apt install build-essential -y
sudo apt install libssl-dev -y
sudo apt install gdb -y
installation_end "build-essential"

# install development tools
installation_info "cmake 3.22.4"
# Could NOT find OpenSSL, try to set the path to OpenSSL root folder problem
sudo apt install libssl-dev
# CMake 3.22.4
wget https://github.com/Kitware/CMake/releases/download/v3.22.4/cmake-3.22.4.tar.gz
tar zxvf cmake-3.22.4.tar.gz
cd cmake-3.22.4
./bootstrap
make
sudo make install
installation_end "cmake 3.22.4"

installation_info "git"
sudo apt install git -y
installation_end "git"

# install editor 
installation_info "vim"
sudo apt install vim
installation_end "vim"

# TODO:check valid or not
installation_info "code"
sudo snap install --classic code
installation_end "code"

installation_info "pip"
sudo apt install python3-pip -y
installation_end "pip"

# install network related
installation_info "nmap"
sudo apt install nmap
installation_end "nmap"

# install utils
installation_info "tree"
sudo apt install tree
installation_end "tree"

# install some libraries for project - LRA on Raspberry 4b
# C++ fmt
installation_info "fmt"
# TODO:check fmt existed or not
if [ ! -d "/usr/local/include/fmt" ]
then
    git clone https://github.com/fmtlib/fmt.git
    cd fmt
    mkdir build 
    cd build
    cmake ..
    sudo make install
    cd ../..
fi
installation_end "fmt"

# wiringPi
installation_info "wiringPi"
# Oops model 17 problem
sudo dpkg --add-architecture armhf
sudo apt update
wget https://github.com/guation/WiringPi-arm64/releases/download/2.61-g/wiringpi-2.61-g.deb
sudo apt install -f ./wiringpi-*-g.deb

# gpio -readall group problem
sudo apt install rpi.gpio-common
sudo adduser $(USER) dialout

installation_end "wiringPi"

# install libi2c
installation_info "libi2c-dev"
sudo apt install libi2c-dev -y
installation_end "libi2c-dev"

# vcgencmd
installation_info "vcgencmd"
sudo apt install libraspberrypi-bin -y
sudo usermod -aG video $(USER)
installation_end "vcgencmd"

# main program
installation_info "LRA main program"
# store current path
PARENT_PATH = $(pwd)
# go to /~
cd ~
# clone from git
git clone https://github.com/DennisLiu16/LRA_Raspberry4b.git

installation_end "LRA main program"

# TODO:add global and git alias

# TODO:if reboot flag on
sudo reboot



