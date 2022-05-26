#!/bin/bash
# Author: DennisLiu16

# Version: 1.0

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
installation_end "build-essential"

# install development tools
installation_info "cmake"
sudo apt install cmake -y
installation_end "cmake"

installation_info "git"
sudo apt install git -y
installation_end "git"

# install editor 
installation_info "vim"
sudo apt install vim
installation_end "vim"

installation_info "code"
sudo snap install --classic code
installation_end "code"

# install network related
installation_info "nmap"
sudo apt install nmap
installation_end "nmap"

# install utils
installation_info "tree"
sudo apt install tree
installation_end "tree"

# install some libraries for project - LRA
# C++ fmt
installation_info "fmt"
git clone https://github.com/fmtlib/fmt.git
cd fmt
mkdir build 
cd build
cmake ..
cd ..
sudo make install
installation_end "fmt"

# wiringPi
installation_info "wiringPi"
sudo apt-get install wiringPi
installation_end "wiringPi"

# vcgencmd
installation_info "vcgencmd"
sudo apt install libraspberrypi-bin
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



