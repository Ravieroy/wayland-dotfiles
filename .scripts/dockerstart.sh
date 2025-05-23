#! /bin/bash

# Step-1 :
	# ---> Folder ---> set_env(./setantenv.sh)--->run_docker(sudo docker start containerID)
	# ---> buildjava(antall)--->start_hybris_server(./hybrisserverstart)
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

# checks if docker exists
check_docker(){
if [[ $(which docker) ]]; then
   IS_DOCKER=1
else
   echo "${txtred}Docker not found${txtrst}"
   exit 1
fi
}

# checks if directory given as argument exists or not
# syntax : is_directory dir_name
is_directory(){
	if [ -d "$1" ]; then
		echo "${txtgrn}$1 found${txtrst}"
	else
		echo "${txtred} $1 directory not found${txtrst}"
		exit 1
fi
}

# checks if file given as argument exists or not
# syntax : is_file dir_name
is_file(){
	if [ -f "$1" ]; then
		echo "${txtgrn}$1 found${txtrst}"
	else
		echo "${txtred}$1 file not found ${txtrst}"
		exit 1
	fi
}

# variables
FOLDER_PATH=$HOME/01-MyStuffs
ENV_FILE=test.sh

# driver code
main(){
	# changing to FOLDER_PATH
	is_directory "$FOLDER_PATH"
	cd "$FOLDER_PATH" || exit

	# setting ENV
	echo "${txtgrn}[main]Setting environment${txtrst}"
	is_file $ENV_FILE
	# ./$ENV_FILE

	#run docker
	# check_docker
	echo "${txtgrn}[main]Running Docker ${txtrst}"
	# docker command here 

	# build java
	echo "${txtgrn}[main]Building Java ${txtrst}"
	# java command here 

	# build hybris server
	echo "${txtgrn}[main]Building Server ${txtrst}"
	# hybris server command here 
}

# call main function

main
