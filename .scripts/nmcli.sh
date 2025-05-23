#! /bin/bash

#For text colors
clear
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)

echo "${txtylw}Scanning Wifi${txtrst}"
nmcli d wifi rescan
echo "${txtgrn}Wifi List${txtrst}"
nmcli d wifi list

echo -e "${txtgrn}Enter the name of the SSID you want to connect: ${txtrst} \c"
read wifi_name
nmcli d wifi connect $wifi_name --ask