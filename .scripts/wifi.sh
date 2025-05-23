#! /bin/bash
   
#For text colors
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)

echo "${txtylw}Getting Wifi list${txtrst}"
nmcli -t -f ,ssid dev wifi > ssid.txt
nmcli -t -f ,bssid dev wifi | sed 's/\\//g' > bssid.txt
nl ssid.txt
n_lines=$(wc -l < ssid.txt)
read -p "${txtgrn}Enter your choice:[1-$n_lines] ${txtrst}" input
wifi_name=$(sed -n -e "$input"p ssid.txt)
bssid=$(sed -n -e "$input"p bssid.txt)
echo "${txtylw}Connecting "$wifi_name" ...${txtrst}"

nmcli d wifi connect "$bssid" --ask
rm ssid.txt
rm bssid.txt
