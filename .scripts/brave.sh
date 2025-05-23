#! /bin/bash

#----For color-----

txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)

# for columns
COLUMNS=$(tput cols)

# for alignment in center
center() {
	w=$(( $COLUMNS / 2 - 60 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

centerwide() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

# Installation for Debian based distro : Ubuntu, popOS, mint

brave_install_ubuntu(){

brave-browser --version
if [ $? -eq 0 ]; then
    echo "${txtgrn}Brave Browser already exists${txtrst}" | centerwide
else
	
    echo "${txtylw}Starting process to install Brave Browser${txtrst}" | centerwide
    sleep 1

    sudo apt install apt-transport-https curl

    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    sudo apt update

    echo "${txtylw}Installing Brave: Almost done ${txtrst}"  | centerwide

    sudo apt install brave-browser

    echo "${txtylw}Done!!!${txtrst}" | centerwide
fi
}

# Complete removal of brave browser

brave_uninstall_ubuntu(){

brave-browser --version
if [ $? -eq 0 ]; then

    echo "${txtred}This will completely remove your Brave installation:${txtrst}" | centerwide
    sleep 0.5

    echo -e "${txtgrn}Do you want to continue (Y/n)? : \c${txtrst}"
    read input
        if [ -z "$input" ]
        then
                input=Y
        fi
    case $input in
        "Y" | "y" )
        sudo apt -y remove brave-browser && sudo apt -y purge brave-browser && rm -rf ~/.config/BraveSoftware && rm -rf ~/.cache/BraveSoftware
        sudo apt autoremove
        echo "${txtylw}Uninstall complete${txtrst}" ;;
        "n" )
         brave-browser --version  ;;
    esac

else
    echo "${txtylw}Brave doesn't exist${txtrst}"
fi
}


function show_menu(){
date | centerwide
echo "${txtylw}-------------------------------${txtrst}" | centerwide
echo "${txtgrn} Main Menu ${txtrst}" | centerwide
echo "${txtylw}-------------------------------${txtylw}" | centerwide
echo "${txtgrn}1. Install Brave for Debian/Ubuntu based distros${txtrst}" | centerwide
echo "${txtgrn}2. Completely remove Brave for Debian/Ubuntu based distros${txtrst}" | centerwide
echo "${txtgrn}3. Exit${txtrst}" | centerwide
}



function read_input(){
local input
read -p "${txtylw}Enter your choice [ 1 -3 ] ${txtrst}" input
case $input in
    1) brave_install_ubuntu ;;
    2) brave_uninstall_ubuntu ;;
    3) echo "${txtgrn}Bye!${txtrst}"; exit 0 ;;
    *)
    echo "Please select from 1 to 3."
esac
}

message(){
    echo "${txtgrn}This script has been tested for Debian/Ubuntu based distros. When you uninstall Brave using this script, no traces or previous settings will remain${txtrst}"
    echo "${txtgrn}For other distros visit: https://brave.com/linux/ ${txtrst}"
    echo " "
}

trap '' SIGINT SIGQUIT SIGTSTP

message
sleep 3
clear
show_menu
read_input

