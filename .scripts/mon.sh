#! /bin/bash

#This function checks for root access to display system information it is working on.

chk_root() {
	local meid=$(id -u)
	if [ $meid -ne 0 ]; then
		echo "You are not root user. Can not display System Information!!"
		#exit 999
    else
        echo " Monitoring usage for: "
        dmidecode | grep -A3 '^System Information'
    fi
}

#This function checks if you are on AC or battery power.

chk_stat(){
    val=$(cat /sys/class/power_supply/AC/online)

if [ $val -eq 1 ]
then    
    echo "You are on AC Power"
else
    echo "You are on battery power"
fi
}

#This function creates neccessary files for script execution

imp_files(){
    for files in log.txt times.txt
    do 
        if [ -e $files ] # -e is for file exist or not
        then 
        if [ -w $files ] # -w is to check if file is writable or not
        then
        continue
            #echo "$files is writable"
        else
            echo "$files is  not writable: Providing write permissions: "
            sleep 1
            chmod +w $files
            echo "$files is now has write permissions"
        fi
        else
            echo "$files not found: Creating..."
            sleep 1
            echo "$files created"
            touch $files
        fi

  done
}

#Running above functions
chk_root
chk_stat
imp_files

start="SESSION STARTED"
stop="SESSION STOPPED"

echo -e "Power ON/OFF ? \c"
read input

case $input in
            "ON" | 'on' )
            time_on=$(date +'%a %d %b  %Y %T')
            echo "--------------------------------------------- " >> log.txt
            echo "$start " >> log.txt 
            #bat_stat=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|to\ full|percentage")
            bat_stat=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "percentage" )
            echo "Battery $bat_stat " >> log.txt
            echo "Power ON: $time_on " >> log.txt
            echo "$time_on" > times.txt ;;
            "OFF" | 'off' )
            time_off=$(date +'%a %d %b  %Y %T')
            #bat_stat=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|to\ full|percentage")
            bat_stat=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "percentage" )
            echo "Battery $bat_stat " >> log.txt
            echo "Power OFF: $time_off " >> log.txt
            echo "$stop " >> log.txt 
            echo "--------------------------------------------- " >> log.txt
            echo "$time_off" >> times.txt ;;
            
            * )
            echo "Wrong Choice"
            
        esac


stro=$(head -1 times.txt)
echo "$stro"
strf=$(sed -n -e 2p times.txt)
echo "$strf"


echo " $strf 
$stro" | (read off_time; read on_time;
on_seconds=$(date --date="$on_time" +%s);
off_seconds=$(date --date="$off_time" +%s);
echo $(((off_seconds-on_seconds)/60)) "minutes") >> log.txt

