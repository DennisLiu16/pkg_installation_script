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
    echo "Usage: [-a --all][-h --help][--reboot][--onPi][--LRA][-p <project>]
    
    [-a -all] : enable all flags
    [-h --help] : print usage
    [--reboot] : enable reboot after all installation
    [--onPi] : run the script on raspberry hardware
    [-p <project>] : run the script for specific <project>
    [--LRA] : special usage for LRA project
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
    # CMake 3.22.4
    if [[ $ONPI = true && $PROJECT = "LRA" ]];then
        installation_info "cmake 3.22.4"
        if ! which cmake 2>/dev/null; then
            # install binary files directly
            # install path to /opt/cmake
            cd /opt
            # sudo wget https://github.com/Kitware/CMake/releases/download/v3.22.4/cmake-3.22.4-linux-aarch64.sh
            # sudo chmod +x cmake-3.22.4-linux-aarch64.sh

            sudo wget https://github.com/Kitware/CMake/releases/download/v3.22.4/cmake-3.22.4-linux-aarch64.tar.gz
            sudo tar zxvf cmake-3.22.4-linux-aarch64.tar.gz

            # link to usr/local/bin
            sudo ln -s /opt/cmake-3.22.4-linux-aarch64/bin/* /usr/local/bin/
            cd $PARENT_PATH
        else
            cmake --version
            color_red "cmake already installed, this project required cmake 3.22.4.
                \nPlease installed it manually or remove it first"
            echo -e $color_word
            sleep 5s
        fi
    else
        installation_info "cmake default"
        sudo apt install cmake -y
        installation_end "cmake default"
    fi

    # linux-tool - perf
    installation_info "linux-tool"
    sudo apt install linux-tools-raspi
    installation_end "linux-tool"

    # git
    installation_info "git"
    sudo apt install git -y
    git config --global core.editor vim
    # add some useful aliases
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
    installation_end "git"

    # install editor 
    installation_info "vim"
    sudo apt install vim
    installation_end "vim"

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

    # add vscode
    installation_info "code normal"
    sudo apt install code
    installation_end "code normal"

    # add boost lib
    installation_info "C++ boost"
    sudo apt install libboost-all-dev
    installation_end "C++ boost"

    # add spdlog lib
    # installation_info "C++ spdlog lib" //version too old 1.5.0
    # sudo apt install libspdlog-dev
    # installation_end "C++ spdlog lib"
}

function install_ubuntu_LRA_onpi() {
    # change time zone
    sudo timedatectl set-timezone Asia/Taipei

    # add code for aarch64 (ARM64)
    cd $PARENT_PATH
    installation_info "VS Code arm64 stable"
    if [ ! -f ./code.deb ];then
        wget https://update.code.visualstudio.com/latest/linux-deb-arm64/stable -O code.deb
        sudo dpkg -i code.deb
        sudo apt --fix-broken install -y
        sudo dpkg -i code.deb

        code --install-extension austin.code-gnu-global
        code --install-extension cschlosser.doxdocgen
        code --install-extension Gruntfuggly.todo-tree
        code --install-extension jeff-hykin.better-cpp-syntax
        code --install-extension ms-python.python
        code --install-extension ms-python.vscode-pylance
        code --install-extension ms-toolsai.jupyter
        code --install-extension ms-toolsai.jupyter-keymap
        code --install-extension ms-toolsai.jupyter-renderers
        code --install-extension ms-vscode.cmake-tools
        code --install-extension ms-vscode.cpptools
        code --install-extension ms-vscode.cpptools-extension-pack
        code --install-extension ms-vscode.cpptools-themes

        # maximum file watcher number of vscode (debug usage)
        # ref: https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
        if [ ! grep 'max_user_watches' /etc/sysctl.conf ];then
            echo 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.conf
            sudo sysctl -p
        fi
    else
        color_green "VS Code already downloaded"
        echo -e $color_word
    fi
    installation_end "VS Code arm64 stable"

    # confirm cmake state
    if which cmake 2>/dev/null ;then
        installation_end "cmake 3.22.4"
    else
        color_red "cmake 3.22.4 installation failed, please check it\n\n"
        echo -e $color_word
        sudo dpkg --configure -a
    fi

    installation_info "s-tui"
    sudo pip install s-tui
    installation_end "s-tui"

    # install some libraries for project - LRA on Raspberry 4b
    # C++ fmt
    installation_info "fmt"
    # TODO:check fmt existed or not
    if [[ ! -d /usr/local/include/fmt && ! -d /usr/include/fmt ]]
    then
        cd $PARENT_PATH
        git clone https://github.com/fmtlib/fmt.git
        cd fmt
        mkdir build 
        cd build
        cmake ..
        sudo make install
        cd $PARENT_PATH
    else
        echo "fmt already installed"
    fi
    installation_end "fmt"

    # wiringPi
    installation_info "wiringPi"
    cd $PARENT_PATH
    if [ -f ./wiringpi-2.61-g.deb ] ; then
        color_green "wiringpi-2.61-g.deb already downloaded"
        echo -e $color_word
    else
    # Oops model 17 problem
        sudo dpkg --add-architecture armhf
        sudo apt update
        wget https://github.com/guation/WiringPi-arm64/releases/download/2.61-g/wiringpi-2.61-g.deb
    fi
    sudo apt install -f ./wiringpi-*-g.deb -y

    # gpio -readall group problem
    sudo apt install rpi.gpio-common
    sudo adduser $(USER) dialout

    installation_end "wiringPi"

    # install libi2c
    installation_info "libi2c-dev"
    sudo apt install libi2c-dev -y
    # add $USER to i2c group
    sudo adduser $USER i2c
    # sudo su $USER
    installation_end "libi2c-dev"

    # vcgencmd
    installation_info "vcgencmd"
    sudo apt install libraspberrypi-bin -y
    sudo usermod -aG video $(USER)
    installation_end "vcgencmd"

    # main program
    installation_info "LRA main program"
    if [ ! -d ~/LRA_Raspberry4b ];then
        # clone from git
        cd ~
        git clone https://github.com/DennisLiu16/LRA_Raspberry4b.git
        # build
        cd LRA_Raspberry4b/build
        cmake ..
        make
        # TODO:maybe add build or something here
        cd $PARENT_PATH

        # setting spi config
        GROUP="spi"
        if [ ! $(getent group $GROUP) ]; then
            sudo groupadd $GROUP
            # sudo su $USER
        fi

        if  id -nG "$USER" | grep -qw "$GROUP" ; then
            #ignore
            echo "$USER was already in $GROUP"
        else
            sudo adduser $USER $GROUP
            # sudo su $USER
        fi

        if grep '#for LRA SPI' /etc/udev/rules.d/50-spi.rules ; then
            echo "50-spi.rules for LRA already exists"
        else
            # avoid >> error
            color_green '\n\nset rule for LRA spi\n\n'
            echo -e $color_word
            echo -e "#for LRA SPI\nSUBSYSTEM==\"spidev\",KERNEL==\"spidev0.*\",GROUP=\"spi\",MODE=\"0660\"" | sudo tee -a /etc/udev/rules.d/50-spi.rules
        fi

        # setting pwm config
        

    else
        echo "LRA_Raspberry4b already existed at default path"
    fi
    installation_end "LRA main program"

    # LRA web
    installation_info "LRA Web"
    if [ ! -d ~/LRA_Web ];then
        cd ~
        git clone https://github.com/DennisLiu16/LRA_Web.git
        # packages required
        pip install django
        pip install channels
        pip install matplotlib
        pip install prettytable
        cd LRA_Web
        # create tables
        python manage.py migrate

        # TODO:auto runserver cmd

        cd $PARENT_PATH
    else 
        echo "LRA_Web already existed at default path"
    fi
    installation_end "LRA Web"

    # TODO:add global alias
    if [ grep 'getMAC' ~/.bash_aliases ];then
        color_green "Aliases already existed"
        echo -e $color_word
    else
        cd ~
        echo "alias cdc='cd ~/LRA_Raspberry4b'" >> .bash_aliases
        echo "alias cdw='cd ~/LRA_Web'">> .bash_aliases
        # wifi 
        echo "alias getMAC='cat /sys/class/net/wlan0/address'" >> .bash_aliases
        # measure
        echo "alias temp='vcgencmd measure_temp'" >> .bash_aliases
    fi
    cd $PARENT_PATH
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
    ARGS=$(getopt -o "ap:h" --long help,all,reboot,onPi,LRA,project: -- "$@" 2>&1) || exit
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
        shift 
    ;;
    --onPi)
        ONPI=true
        shift    
    ;;
    --LRA)
        PROJECT="LRA"
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

if [ $ONPI = true ];then
    color_red $ONPI
    sONPI=$color_word
else
    sONPI=$ONPI
fi

if [ $ENABLE_REBOOT = true ];then
    color_red $ENABLE_REBOOT
    sENABLE_REBOOT=$color_word
else
    sENABLE_REBOOT=$ENABLE_REBOOT
fi

if [ ! $PROJECT = none ];then
    color_green $PROJECT
    sPROJECT=$color_word
else
    sPROJECT=$PROJECT
fi

if [ $ENABLE_ALL = true ];then
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
if [ ! -d ./pkg_tmp ];then
    mkdir ./pkg_tmp
fi
cd ./pkg_tmp

# store current path
PARENT_PATH=$(pwd)

# update 
sudo apt update -y
sudo apt upgrade -y

# install development tools in ubuntu
install_ubuntu_dev

# install LRA project depend software and alias
if [[ $PROJECT = "LRA" && $ONPI = true ]];then
    color_red "project is LRA"
    echo -e $color_word
    install_ubuntu_LRA_onpi
fi

sudo apt update -y
sudo apt upgrade -y

# if reboot flag on
if [ $ENABLE_REBOOT = true ];then
    echo "reboot starts"
    sudo reboot
else
    sudo su $USER
fi

# What's new in version 3
## clang
## vscode extension - emilast.LogFileHighlighter
## apt install spdlog lib change to git clone header into third_party/spdlog
## g++-11

