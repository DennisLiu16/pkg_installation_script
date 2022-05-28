# Scripts for development tools installation 

## V2
- Add flags for different project installation requirements
    e.g. --LRA or using -p LRA

## How to use
1. Download repo

    ```
    git clone https://github.com/DennisLiu16/pkg_installation_script.git
    ```

2. Find script path **Ubuntu_packages.sh** and cd there.

3. Execute the script with arguments

    ```
    Usage: [-a --all][-h --help][--reboot][--onPi][--LRA][-p <project>]
    
    [-a -all] : enable all flags
    [-h --help] : print usage
    [--reboot] : enable reboot after all installation
    [--onPi] : run the script on raspberry hardware
    [-p <project>] : run the script for specific <project>
    [--LRA] : special usage for LRA project
    ```

## Example
```bash
# clone this repo at current path
git clone https://github.com/DennisLiu16/pkg_installation_script.git

# go to find the script
cd pkg_installation_script/OS/Ubuntu

# run the script with args
# for examples 
# project : LRA
# OS : Ubuntu 20.04 LTS on raspberry 4b
# reboot : true
./Ubuntu_packages.sh -p LRA --onPi --reboot

# or 
./Ubuntu_packages.sh --LRA --reboot
```
    