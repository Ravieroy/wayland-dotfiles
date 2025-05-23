#!/bin/sh

FAN_SPEED=$(sensors |grep -i fan | awk '{ gsub(/[ ]+/," "); print $2 }')
#FULL_FAN_SPEED=$(sensors |grep -i fan | awk '{ gsub(/[ ]+/," "); print $2 " " $3 }' )
 
echo $FAN_SPEED # full text

# color
if [[ $FAN_SPEED -eq 0 ]]; then
    echo "#00FF00"
elif [[ $FAN_SPEED -ge 2000 ]]; then
    echo "#FFF600"
elif [[ $FAN_SPEED -ge 2500 ]]; then
    echo "#FFAE00"
else
    echo "#FF0000"
fi

