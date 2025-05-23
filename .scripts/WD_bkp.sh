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


#For distribution check

check_distribution(){
if [[ `which pacman` ]]; then
   IS_ARCH=1
   echo "${txtylw}-------------------------------${txtrst}"
   echo "${txtylw} THIS IS AN ARCH BASED DISTRO  ${txtrst}"
   echo "${txtylw}-------------------------------${txtrst}"

elif [[ `which apt` ]]; then
   IS_UBUNTU=1
   echo "${txtylw}--------------------------------${txtrst}"
   echo "${txtylw} THIS IS A DEBIAN BASED DISTRO  ${txtrst}"
   echo "${txtylw}--------------------------------${txtrst}"
else
   IS_UNKNOWN=1
fi
}

#Check for python

check_python(){
if [[ `which python` ]]; then
   IS_PYTHON=1
   echo "${txtylw}Python is installed${txtrst}"
else
   IS_PYTHON=0
   echo "${txtred}Python not found${txtrsr}"
fi
}

#Check for git

check_git(){
if [[ `which git` ]]; then
   IS_GIT=1
   echo "${txtylw}Git is installed${txtrst}"
else
   IS_GIT=0
   echo "${txtred}Git not found${txtrsr}"
fi
}

#Check for sg3-utils

check_sg3(){
if [[ `which sg_verify` ]]; then
   IS_SG3=1
   echo "${txtylw}sg3_utils is installed${txtrst}"
else
   IS_SG3=0
   echo "${txtred}sg3_utils not found${txtrsr}"
fi
}

check_dependencies(){

    echo "${txtylw}Checking for dependencies.${txtrst}"
    sleep 1

    check_python
    check_git
    check_sg3

    myvar=$(expr $IS_PYTHON + $IS_GIT + $IS_SG3)
    
    if [[ $myvar -eq 3 ]]; then
        echo "${txtylw}All dependencies are satisfied.Proceeding ahead${txtrst}"
        sleep 1
    fi
}

install_dependencies(){
    if [[ $IS_PYTHON -eq 0 ]]; then
            if [[ $IS_UBUNTU -eq 1 ]]; then
                echo "${txtylw}Installing Python${txtrst}"
                sudo apt install python -y
                clear
            elif [[ $IS_ARCH -eq 1 ]]; then
                echo "${txtylw}Installing Python${txtrst}"
                sudo pacman -S python
                clear
            fi
    fi
    if [[ $IS_GIT -eq 0 ]]; then
            if [[ $IS_UBUNTU -eq 1 ]]; then
                echo "${txtylw}Installing git${txtrst}"
                sudo apt install git -y
                clear
            elif [[ $IS_ARCH -eq 1 ]]; then
                echo "${txtylw}Installing git${txtrst}"
                sudo pacman -S git
                clear
            fi
    fi
    if [[ $IS_SG3 -eq 0 ]]; then
            if [[ $IS_UBUNTU -eq 1 ]]; then
                echo "${txtylw}Installing sg3-utils${txtrst}"
                sudo apt install sg3-utils -y 
                clear
            elif [[ $IS_ARCH -eq 1 ]]; then
                echo "${txtylw}Installing sg3-utils${txtrst}"
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

#cloning github repo

git_repo(){
  echo "${txtylw}cloning git repo by geekhaidar${txtrst}"
  git clone https://github.com/geekhaidar/WD-Passport-Unlock-Linux.git
}

#For default confirmation Y/n

default_confirm(){
  if [ -z "$input" ]; then
    input=Y
  fi
}

#To check directory exists or not

check_dir(){

##DIR="$HOME/WD-Passport-Unlock-Linux"

DIR="$PWD/WD-Passport-Unlock-Linux"

if [ ! -d "$DIR" ]; then
echo "${txtred}ERROR : ${DIR} does not exists.${txtrst}"
echo -e "${txtylw}Would you like to clone it from geekhaider's github repo${txtrst} ? [Y/n] \c "
read input 
default_confirm
    case $input in
            "Y" | "y" )
            git_repo ;;
            "N" | "n" )
            echo "${txtred}can not proceed without it. Quitting${txtrst}"
            exit 999 ;;

            * )
            echo "${txtred}Please make a correct choice.Thank You.${txtrst}"
            exit 999 ;;
    esac 
else

echo "${txtylw}Directory found. Proceeding ahead${txtrst}"
sleep 2
fi  
}

chk_input_disk(){
  if [ -z "$disk" ]; then
    echo "${txtred}WARNING: Cannot Proceed without disk name:${txtrst}"
    echo -e "${txtgrn}Please enter the Attached SCSI disk name ${txtrst} \c"
    read disk 
  fi
}

disk_exit(){
  if [ -z "$disk" ]; then
    echo "${txtred}ERROR: Cannot Proceed without disk name: Exiting Now.${txtrst}" 
    exit 999
  fi
}


#Start unlocking

start_unlock(){
  echo "${txtylw}Changing Directory${txtrst}"
  cd $PWD/WD-Passport-Unlock-Linux
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
check_dir
clear
start_unlock
