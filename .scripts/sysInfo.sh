#! /bin/bash

# A simple shell script to show most common system information.
# You require acpi installed to display battery info. It would work either way
# Made by Ravi roy (https://github.com/ravieroy)


#----For color-----

txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)


message(){
    echo "${txtred}.........ATTENTION.......................${txtrst}"
    echo "${txtylw}If your distribution is anything other than Debian/Ubuntu, Please make sure you have acpi and dmidecode installed.${txtrst}"
    echo "${txtylw}For Debian/Ubuntu based distros you will be prompted to install directly.${txtrst}"
    sleep 7
}

#--------------------

#This function checks for root access 

chk_root() {
	local meid=$(id -u)
	if [ $meid -ne 0 ]; then
		echo "${txtred}ATTENTION: You are not root user. This will work best if you are root.${txtrst}"
		exit 999
    fi
}

#This is required in system which doesn't have dmidecode by default

install_dmidecode(){

if ! dmidecode --version; then
    echo -e "${txtred}ATTENTION: ${txtrst}dmidecode needs to be installed for complete execution. Do you want to install(Debian/Ubuntu) (Y/n)? \c"
    read input
    if [ -z "$input" ]
    then
            input=Y
    fi
    case $input in
        "Y" | "y" )
        if [ -z $(hostname -I | awk '{print $1}') ]
        then
            echo "${txtred}Cannot Install dmidecode. Your system has no internet connection${txtrst}" 
            echo "${txtylw}Continuing without dmidecode${txtrst}"
            sleep 3
        else
            sudo apt -y install dmidecode
            echo "${txtylw}Installation complete: Displaying sytem information now${txtrst}"
            sleep 3 
        fi ;;
        "N" | "n" )
         echo "${txtred}Will display some errors!!${txtrst}"
         sleep 2 ;;

         * )

         echo "${txtred}Please make a correct choice.Thank You.${txtrst}"
         exit 999

    esac 
fi 
}

#------------------------

#This installs acpi for battery info
install_acpi(){

if ! acpi; then
    echo -e "${txtred}ATTENTION: ${txtrst}acpi needs to be installed to display battery information. Do you want to install(Debian/Ubuntu) (Y/n)? \c"
    read input
    if [ -z "$input" ]
    then
            input=Y
    fi
    case $input in
        "Y" | "y" )
        if [ -z $(hostname -I | awk '{print $1}') ]
        then
            echo "${txtred}Cannot Install acpi. Your system has no internet connection${txtrst}" 
            echo "${txtylw}Continuing without acpi${txtrst}" 
            sleep 3
        else
            sudo apt install acpi -y
            echo "${txtylw}Installation complete: Displaying sytem information now${txtrst}"
            sleep 1
            
        fi ;;
        "N" | "n" )
         echo "${txtred}Can't show battery info${txtrst}" 
         sleep 2 ;;

         * )

         echo "${txtred}Please make a correct choice.Thank You.${txtrst}"
         exit 999
    esac 
fi 
}

# To check for empty slot in memory
mem_slot(){
lshw -short -C memory | grep -i empty
if [ $? -ne 0 ]; then
    echo "${txtgrn}You do not have any empty memory slots${txtrst}"
else
	
    echo "${txtgrn}You have empty memory slot${txtrst}"
fi
}


# Define variables
LSB=/usr/bin/lsb_release






# This function contains all the process 

process(){

echo "${txtylw}--------------------------------SYSTEM-------------------------------------------------${txtrst}"
echo " "

dmidecode | grep -A4 '^System Information'  #provides system information

echo " "
echo "${txtylw}--------------------------------ARCHITECTURE-------------------------------------------${txtrst}"


echo "System $(lscpu | grep -i architecture)"  # architecture 64 or 32 bits

echo " "
echo "${txtylw}----------------------------------BATTERY----------------------------------------------${txtrst}" 


echo "Battery : $(dmidecode | grep -i design\ capacity)" # battery capacity

if acpi; then
    echo " " 
else
    echo "${txtred}acpi not found!! Can't display battery capacity.${txtrst}"
    echo ""
fi

echo " "

echo "${txtylw}----------------------------------SCREEN-----------------------------------------------${txtrst}"


#echo "Screen Dimension: $(xdpyinfo | awk '/dimensions/{print $2}')" #Screen dimension
#xdpyinfo | grep resolution #Screen Resolution #DPI
echo "Screen Resolution and Refresh rate: $(xrandr | grep -i "\*") "



echo " "
echo "${txtylw}----------------------------------LANGUAGE---------------------------------------------${txtrst}"


echo $(dmidecode -t bios | grep -i installed\ language) #installed language

echo " "
echo "${txtylw}------------------------------------OS-------------------------------------------------${txtrst}"


echo "Operating system : $(uname)"
[ -x $LSB ] && $LSB -a || echo "$LSB command is not insalled (set \$LSB variable)"

echo " "
echo "${txtylw}---------------------------------------------------------------------------------------${txtrst}"


lscpu | grep -i mhz #CPU maximum in mHz

echo " "
echo "${txtylw}-----------------------MAXIMUM MEMORY FOR HARDWARE-------------------------------------"${txtrst}


dmidecode -t memory | grep -i maximum\ capacity #max memory installable

echo " "
echo "${txtylw}--------------------------EMPTY SLOT---------------------------------------------------${txtrst}"

mem_slot # function to check if there is space for memory stick

echo " "
echo "${txtylw}--------------------------------RAM INFO-----------------------------------------------${txtrst}"

free -h --si  #current memory use

echo " "
echo "${txtylw}--------------------------------DISK SIZE----------------------------------------------${txtrst}"

echo "Your disk $(lshw -c disk | grep -i size:)" #Disk size

echo " "
echo "${txtylw}-------------------------------RELEASE DATE--------------------------------------------${txtrst}"


dmidecode -t bios | grep -i release\ date # Release date 

echo " "
echo "${txtylw}------------------------------------ROM------------------------------------------------${txtrst}"


dmidecode -t bios | grep -i rom\ size #ROM Size

echo " "
echo "${txtylw}---------------------------------------------------------------------------------------${txtrst}"


dmidecode -t bios | grep -i usb\ legacy # is usb legacy supported

echo " "
echo "${txtylw}----------------------------------UEFI-------------------------------------------------${txtrst}"


dmidecode -t bios | grep -i uefi # is uefi supported 

echo " "
echo "${txtylw}---------------------------------CPU---------------------------------------------------${txtrst}"


lshw -C cpu | grep -i configuration # cores threads

echo " "
echo "${txtylw}--------------------------------PROCESSOR----------------------------------------------${txtrst}"


lshw -C cpu | grep -i product # Processor 

echo " "
echo "${txtylw}------------------------------IP Address-----------------------------------------------${txtrst}"

if [ -z $(hostname -I | awk '{print $1}') ]
then
    echo "${txtred}Cannot display IP address. Your system has no internet connection${txtrst}"
else
    echo "${txtcyn}Your IP address for ssh connection : $(hostname -I | awk '{print $1}')${txtrst}"
fi

echo " "
echo "${txtylw}----------------------------------SSH--------------------------------------------------${txtrst}"


echo " ssh service status"
systemctl status ssh | grep -i active # ssh active/inactive

echo " "
echo "${txtred}-----------------------------------DONE-------------------------------------------------${txtrst}"
}


chk_root
clear
message
install_acpi
install_dmidecode
clear
process