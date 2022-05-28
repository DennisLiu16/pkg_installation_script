#!/bin/bash
# Author: DennisLiu16

# Version: 2

# For any server, the best way to get this script is git clone
# sudo apt install git 
# git clone https://github.com/DennisLiu16/pkg_installation_script

# functions define
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

function usage() {
    echo "Usage: [-a --all][-h --help][--reboot][--onPi][-p <project>]
    
    [-a -all] : enable all flags
    [-h --help] : print usage
    [--reboot] : enable reboot after all installation
    [--onPi] : run the script on raspberry hardware
    [-p <project>] : run the script for specific <project>
    "
    1>&2
}

function color_red() {
    color_word="\033[31m$1\033[0m"
}

function color_green() {
    color_word="\033[32m$1\033[0m"
}

function install_ubuntu_dev() {
    # install ubuntu build essential tool
    # build-essential include [dpkg-dev g++ gcc libc6-dev make]
    # SSL gdb in additional
    installation_info "build-essential"
    sudo apt install build-essential -y
    # Could NOT find OpenSSL, try to set the path to OpenSSL root folder problem
    sudo apt install libssl-dev -y
    sudo apt install gdb -y
    installation_end "build-essential"

    # install development tools
    installation_info "cmake 3.22.4"

    # CMake 3.22.4
    wget https://github.com/Kitware/CMake/releases/download/v3.22.4/cmake-3.22.4.tar.gz
    tar zxvf cmake-3.22.4.tar.gz
    cd cmake-3.22.4
    ./bootstrap
    make
    sudo make install
    installation_end "cmake 3.22.4"

    # git
    installation_info "git"
    sudo apt install git -y
    installation_end "git"

    # install editor 
    installation_info "vim"
    sudo apt install vim
    installation_end "vim"

    # check valid or not
    installation_info "code"
    sudo snap install --classic code
    installation_end "code"

    installation_info "pip"
    sudo apt install python3-pip -y
    installation_end "pip"

    # install network related
    installation_info "nmap"
    sudo apt install nmap -y
    installation_end "nmap"

    # install utils
    installation_info "tree"
    sudo apt install tree
    installation_end "tree"

}

function install_ubuntu_LRA_onpi() {
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
    else
        echo "fmt already installed"
    fi
    installation_end "fmt"

    # wiringPi
    installation_info "wiringPi"
    # Oops model 17 problem
    sudo dpkg --add-architecture armhf -y
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

    # TODO:maybe add build or something here

    installation_end "LRA main program"

    # LRA web
    installation_info "LRA Web"
    git clone https://github.com/DennisLiu16/LRA_Web.git

    # packages required
    pip install django
    pip install matplotlib
    pip install prettytable

    installation_end "LRA Web"

    # TODO:add global and git alias
    cd ~
    echo alias cdc="cd ~/LRA_Raspberry4b" >> .bash_aliases
    echo alias cdw="cd ~/LRA_Web" >> .bash_aliases
    # wifi 
    echo alias getMAC="cat cat /sys/class/net/wlan0/address"
}

# get params
if [ $# -eq 0 ];then
    usage
    exit
fi

if which getopt &>/dev/null; then
    optExist="true"
fi

if [[ "${optExist}"x = "true"x ]]; then
    ARGS=$(getopt -o "ap:h" --long help,all,reboot,onPi,project: -- "$@" 2>&1) || exit
fi

# flags init
ENABLE_ALL=false
PROJECT=none
ENABLE_REBOOT=false
ONPI=false

while true
do 
    case "$1" in
    -h|--help)
        usage
        exit
    ;;
    -a|--all)
        # enable all installation flags
        ENABLE_ALL=true
        ENABLE_REBOOT=true
        ONPI=true
        shift
    ;;
    -p|--project)
        PROJECT="$2"
        shift 2
    ;;
    --reboot)
        ENABLE_REBOOT=true
        shift 1
    ;;
    --onPi)
        ONPI=true
        shift    
    ;;
    --)
        # ignore positional args
        break
    ;;
    *)
        # should not go in here
        break
    esac
    done

if [ $ONPI == true ];then
    color_red $ONPI
    sONPI=$color_word
else
    sONPI=$ONPI
fi

if [ $ENABLE_REBOOT == true ];then
    color_red $ENABLE_REBOOT
    sENABLE_REBOOT=$color_word
else
    sENABLE_REBOOT=$ENABLE_REBOOT
fi

if [ ! $PROJECT == none ];then
    color_green $PROJECT
    sPROJECT=$color_word
else
    sPROJECT=$PROJECT
fi

if [ $ENABLE_ALL == true ];then
    color_red $ENABLE_ALL
    sENABLE_ALL=$color_word
else
    sENABLE_ALL=$ENABLE_ALL
fi

echo "========= FLAGS ==========="
echo -e "onPi : $sONPI"
echo -e "reboot : $sENABLE_REBOOT"
echo -e "enable all : $sENABLE_ALL"
echo -e "project name : $sPROJECT"
echo "==========================="

# main
# create a tmp dir
if [ ! -d "./pkg_tmp" ];then
    mkdir ./pkg_tmp
fi
cd ./pkg_tmp

# update 
sudo apt update -y
sudo apt upgrade -ys

# install development tools in ubuntu
install_ubuntu_dev

# install LRA project depend software and alias
if [[ $PROJECT = "LRA" && $ONPI = true ]];then
    echo "project is LRA"
    install_ubuntu_LRA_onpi
fi

# if reboot flag on
if [ $ENABLE_REBOOT == true ];then
    sudo reboot
fi