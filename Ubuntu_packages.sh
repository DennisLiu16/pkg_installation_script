# Author : DennisLiu16

# In any server, the best way to get this script is install git by
# sudo apt install git 
# git clone <>

# get flags

# create a tmp dir
mkdir "/ubuntu/pkg_tmp"
cd /ubuntu/pkg_tmp
sudo apt install git

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
sudo apt install cmake

# install editor 
sudo apt install vim
sudo apt install code

# install network related
sudo apt install nmap

# install some libraries for project - LRA
# C++ - fmt
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

# group 


