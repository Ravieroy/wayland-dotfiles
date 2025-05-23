#! /bin/bash

# This script takes file name as argument and checks if it is an executable. If it is not, then it makes it executable

if [ $# -eq 0 ]
then
    echo "Error : Wrong Syntax"
    echo "Syntax: $0 fileName"
else

    if [ -e $1 ]
    then 
        if [ -x $1 ] # -e is for file exist or not
        then
        echo "$1 is already an executable!"
        else
        echo "$1 is  not an executable"
        echo -e "Do you want to make it executable? (Y/n) \c"
        read input
            if [ -z "$input" ]
            then
                input=Y
            fi
        case $input in
            "Y" | "y" )
            chmod +x $1 
            echo "File permissions changed" ;;
            "n" )
            echo "File permissions not changed" ;;
        esac
        fi
    else
    echo "$1 not found"
    fi
fi