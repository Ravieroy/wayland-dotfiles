#! /bin/bash

#----Purpose: For color-----

txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)

# Purpose: for columns
COLUMNS=$(tput cols)

# Purpose: for alignment in center
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

#-------------Purpose: To show menu-------------------
function show_menu(){
date | centerwide
echo "${txtylw}-------------------------------${txtrst}" | centerwide
echo "${txtgrn} Main Menu ${txtrst}" | centerwide
echo "${txtylw}-------------------------------${txtylw}" | centerwide
echo "${txtgrn}1. Create a list of all packages installed.${txtrst}" | centerwide
echo "${txtgrn}2. Reinstall all/missing packages from your list${txtrst}" | centerwide
echo "${txtgrn}3. Exit${txtrst}" | centerwide
}


#--------Purpose: To read input-------------------------

function read_input(){
local input
read -p "${txtylw}Enter your choice [ 1 -3 ] ${txtrst}" input
case $input in
    1) create_backup_list ;;
    2) install_pkg ;;
    3) echo "${txtgrn}Bye!${txtrst}"; exit 0 ;;
    *)
    echo "Please select from 1 to 3."
esac
}

#This function creates packages.lst to store package names.

chk_file(){
    for files in packages.lst
    do 
        if [ -e $files ] # -e is for file exist or not
        then

            echo -e "${txtylw}packages.lst from before is found. Would you like to overwrite?${txtrst} ? [Y/n] \c " 
            read input
            enter_confirm
            case $input in
            "Y" | "y" )
            echo "USERNAME: $(whoami)" > packages.lst
            os_name=$(cat /etc/os-release  | awk -F "=" '/PRETTY_NAME/ {print $2}')
            echo "OPERATING SYSTEM: $os_name" >> packages.lst
            echo "Back Up created on: $(date)" >> packages.lst
            ;;
            
            "N" | "n" )
            echo "USERNAME: $(whoami)" >> pop.log
            os_name=$(cat /etc/os-release  | awk -F "=" '/PRETTY_NAME/ {print $2}')
            echo "OPERATING SYSTEM: $os_name" >> pop.log
            echo "Back Up created on: $(date)" >> packages.lst
            ;;

            * )

            echo "${txtred}Please make a correct choice.Thank You.${txtrst}"
            chk_file

            esac 
        if [ -w $files ] # -w is to check if file is writable or not
        then
        continue
            #echo "$files is writable"
        else
            echo "${txtgrn} $files is  not writable: Providing write permissions: ${txtrst}" | centerwide
            sleep 1
            chmod +w $files
            echo "${txtgrn}  $files is now has write permissions${txtrst}" |centerwide
        fi
        else
            echo "${txtgrn} $files not found: Creating packages.lst ${txtred}" | centerwide
            sleep 3
            echo "${txtylw} $files created ${txtrst}" | centerwide
            touch $files
            echo "USERNAME: $(whoami)" >> packages.lst
            os_name=$(cat /etc/os-release  | awk -F "=" '/PRETTY_NAME/ {print $2}')
            echo "OPERATING SYSTEM: $os_name" >> packages.lst
            echo "Back Up created on: $(date)" >> packages.lst
        fi

  done
}

#---------Purpose: Press enter to continue---------------

enter_continue(){
    echo -e "${txtgrn}Press Enter To Continue..${txtrst} \c " 
    read input
    enter_confirm
}

#----------------Purpose:  Press Enter = Yes----------------------------
enter_confirm(){
  if [ -z "$input" ]; then
    input=Y
  fi
}

#---------------Purpose: create backup list---------------
create_backup_list(){
    chk_file
    pkg_count=$(dpkg --get-selections | grep -v "deinstall"|wc -l)
    echo "${txtgrn}Total number packages installed: $pkg_count ${txtrst}" | centerwide
    dpkg --get-selections | grep -v "deinstall" >> packages.lst
    echo "${txtgrn}Back up created successfully.${txtrst}" | centerwide
    enter_continue
    clear
    show_menu; read_input;

}

#-----------Purpose: To check existence of backup file-----

chk_existence(){
    if [ ! -e packages.lst ] # -e is for file exist or not
    then 
        clear
        echo "${txtylw}packages.lst not found. Use option 1 to create the list.${txtrst}" | centerwide
        enter_continue
        clear
        show_menu; read_input;
    fi
}

#-----------Purpose: To check existence of dselect tool-----

chk_dselect(){
    if [[ `which dselect` ]]; then
        IS_DSELECT=1
    else
        IS_DSELECT=0
    fi

    if [[ $IS_DSELECT -eq 0 ]]; then
        echo "${txtylw}dselect tool is required for this. Press Enter to install or ctrl + c to exit. ${txtrst}" | centerwide
        enter_continue
        sudo apt install dselect -y 
    fi
}

#-----------Purpose: To reinstall all packages from the backup file-----

install_pkg(){
    chk_existence
    chk_dselect
    cp packages.lst tmp.lst
    sed -i '1,3d' tmp.lst
    sudo apt install $(cat tmp.lst | awk '{print $1}')
    rm tmp.lst
    sleep 2
    clear
    echo " "
    echo " "
    echo " "
    echo " "
    echo "${txtylw}Packages Restored.${txtrst}" | centerwide
    
    }

clear
show_menu
read_input
