# Author: DennisLiu16

# Version: 1.0

# For any server, the best way to get this script is git clone
# sudo apt install git 
# git clone https://github.com/DennisLiu16/pkg_installation_script

# Todo list
#   - func:getopts

# TODO: get params

# create a tmp dir
mkdir ./pkg_tmp
cd /ubuntu/pkg_tmp

# update 
sudo apt update
sudo apt upgrade

# install ubuntu build essential tool
# dpkg-dev
# g++
# gcc
# libc6-dev
# make
sudo apt install build-essential

# install development tools
sudo apt install cmake
sudo apt install git

# install editor 
sudo apt install vim
sudo apt install code

# install network related
sudo apt install nmap

# install some libraries for project - LRA
# C++ fmt
git clone https://github.com/fmtlib/fmt.git
cd fmt
mkdir build 
cd build
cmake ..
cd ..
sudo make install

# wiringPi
sudo apt-get install wiringPi

# install utils
sudo apt install tree


