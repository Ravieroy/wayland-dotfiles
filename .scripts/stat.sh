#! /bin/bash

check_existence(){
    if ! sensors --version ; then
        echo -e "This requires lm-sensors installed. Do you want to install (Y/n)? \c"
        else 
        echo "Fan speed is: $(sensors | grep -i fan)" 
        echo " " 
        echo " CPU temp is: $(sensors | grep -i temp)" 
        exit 0
    fi
}


begin_process(){
        read input
        if [ -z "$input" ]
        then
            input=Y
        fi
        case $input in
        "Y" | "y" )
        echo "Starting Installation.."
        sudo apt install lm-sensors -y 
        echo "Done."
        clear
        sleep 0.5
        echo "Fan speed is: $(sensors | grep -i fan)" 
        echo " "
        echo "CPU temp is: $(sensors | grep -i temp)";;
        "n" )
        exit 0
        esac

}

check_existence
begin_process
