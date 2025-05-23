#! /bin/bash
#  ____    ____  
# |  _ \  |  _ \   # Ravi Roy (https://github.com/Ravieroy)
# | |_) | | |_) |  # Ravi Roy (https://github.com/Ravieroy/Unlock_WD_HardDisk_Script)
# |  _ < _|  _ < 
# |_| \_(_)_| \_\
#         
     

#For text colors
clear
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
	w=$(( $COLUMNS / 2 - 20 ))
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

#For distribution check

check_distribution(){
if [[ `which pacman` ]]; then
   IS_ARCH=1
   echo "${txtylw}--------------------------------${txtrst}" | centerwide
   echo "${txtylw} THIS IS AN ARCH BASED DISTRO   ${txtrst}" | centerwide
   echo "${txtylw}--------------------------------${txtrst}" | centerwide

elif [[ `which apt` ]]; then
   IS_UBUNTU=1
   echo "${txtylw}---------------------------------${txtrst}" | centerwide
   echo "${txtylw} THIS IS A DEBIAN BASED DISTRO   ${txtrst}" | centerwide
   echo "${txtylw}---------------------------------${txtrst}" | centerwide
else
   IS_UNKNOWN=1
fi
}

#Check for python

check_python(){
if [[ `which python` ]]; then
   IS_PYTHON=1
   echo "${txtylw}Python is installed${txtrst}" | centerwide
else
   IS_PYTHON=0
   echo "${txtred}Python not found${txtrsr}"    | centerwide
fi
}

#Check for git

check_git(){
if [[ `which git` ]]; then
   IS_GIT=1
   echo "${txtylw}Git is installed${txtrst}"     | centerwide
else
   IS_GIT=0
   echo "${txtred}Git not found${txtrsr}"        | centerwide
fi
}

#Check for sg3-utils

check_sg3(){
if [[ `which sg_verify` ]]; then
   IS_SG3=1
   echo "${txtylw}sg3_utils is installed${txtrst}" | centerwide
else
   IS_SG3=0
   echo "${txtred}sg3_utils not found${txtrsr}"    | centerwide
fi 
}

check_dependencies(){

    echo "${txtylw}Checking for dependencies.${txtrst}" | centerwide
    sleep 1

    check_python
    check_git
    check_sg3

    myvar=$(expr $IS_PYTHON + $IS_GIT + $IS_SG3)
    
    if [[ $myvar -eq 3 ]]; then
        echo "${txtylw}All dependencies are satisfied.Proceeding ahead${txtrst}" | centerwide
        sleep 1
    fi
}

install_dependencies(){
    if [[ $IS_PYTHON -eq 0 ]]; then
            if [[ $IS_UBUNTU -eq 1 ]]; then
                echo "${txtylw}Installing Python${txtrst}" | centerwide
                sudo apt install python -y
                clear
            elif [[ $IS_ARCH -eq 1 ]]; then
                echo "${txtylw}Installing Python${txtrst}" | centerwide
                sudo pacman -S python
                clear
            fi
    fi
    if [[ $IS_GIT -eq 0 ]]; then
            if [[ $IS_UBUNTU -eq 1 ]]; then
                echo "${txtylw}Installing git${txtrst}" | centerwide
                sudo apt install git -y
                clear
            elif [[ $IS_ARCH -eq 1 ]]; then
                echo "${txtylw}Installing git${txtrst}" | centerwide
                sudo pacman -S git
                clear
            fi
    fi
    if [[ $IS_SG3 -eq 0 ]]; then
            if [[ $IS_UBUNTU -eq 1 ]]; then
                echo "${txtylw}Installing sg3-utils${txtrst}" | centerwide
                sudo apt install sg3-utils -y 
                clear
            elif [[ $IS_ARCH -eq 1 ]]; then
                echo "${txtylw}Installing sg3-utils${txtrst}" | centerwide
                sudo pacman -S sg3_utils
                clear
            fi
    fi
}

#Required as sometimes error is raised

dmesg_check(){
  if  ! dmesg | grep -i scsi ; then
  sudo sysctl kernel.dmesg_restrict=0
  fi
}

git_repo(){
  echo "${txtylw}cloning Git Repo ${txtrst}" | centerwide
  git clone https://github.com/Ravieroy/WD-Decrypte-Script.git
}

#For default confirmation Y/n

default_confirm(){
  if [ -z "$input" ]; then
    input=Y
  fi
}

chk_input_disk(){
  if [ -z "$disk" ]; then
    echo "${txtred}WARNING: Cannot Proceed without disk name:${txtrst}" | centerwide
    echo -e "${txtgrn}Please enter the Attached SCSI disk name ${txtrst} \c" | centerwide
    read disk 
  fi
}

disk_exit(){
  if [ -z "$disk" ]; then
    echo "${txtred}ERROR: Cannot Proceed without disk name: Exiting Now.${txtrst}"  | centerwide
    exit 999
  fi
}

chk_bin_size(){
  echo "${txtred}The file size should be of 40 bytes${txtrst}" | centerwide
pwd
  echo "${txtylw}The file size of password.bin is (in bytes) $(ls -l password.bin | awk '{print $5}') ${txtrst}" | centerwide
}

check_dir(){

dir_name=${PWD##*/} 
if [ "$dir_name" != "WD-Decrypte-Script"  ]; then
  echo "${txtylw}Looks like you are running the script outside of the cloned directory${txtrst}" | centerwide
  echo "${txtylw}Looking for cloned directory WD-Decrypte-Script${txtrst}" | centerwide

if [ ! -d "WD-Decrypte-Script" ]; then
echo -e "${txtylw}You would need to clone the whole repository. Do you want to clone it now?${txtrst} ? [Y/n] \c " 
read input 
default_confirm
    case $input in
            "Y" | "y" )
            git_repo ;;
            "N" | "n" )
            echo "${txtred}can not proceed without it. Quitting${txtrst}" | centerwide
            exit 999 ;;

            * )
            echo "${txtred}Please make a correct choice.Thank You.${txtrst}" | centerwide
            exit 999 ;;
    esac 
else

echo "${txtylw}Found WD-Decrypte-Script. Proceeding Ahead${txtrst}" | centerwide
sleep 2
fi  
fi
}
#Start unlocking

start_unlock(){
  dir_name=${PWD##*/} 
  if [ "$dir_name" != "WD-Decrypte-Script"  ]; then
    echo "${txtylw}Changing Directory${txtrst}" | centerwide
    cd $PWD/WD-Decrypte-Script
    echo "${txtylw}Starting to decrypte${txtrst}" | centerwide
    sleep 2
  fi

  chk_bin_size
  dmesg | grep -i scsi | grep -i attached
  echo -e "${txtgrn}Please enter the Attached SCSI disk name ${txtrst} \c" 
  read disk 
  chk_input_disk
  disk_exit
  chmod u+x cookpw.py
  read -sp "${txtgrn}Enter password of your WD Hard Disk: ${txtrst}" pass_var 
  ./cookpw.py $pass_var >password.bin
  sudo sg_raw -s 40 -i password.bin /dev/$disk c1 e1 00 00 00 00 00 00 28 00

}


check_distribution
check_dependencies
install_dependencies

dmesg_check
clear
check_dir
#clear
start_unlock

