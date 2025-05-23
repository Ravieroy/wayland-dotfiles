#! /bin/bash

energy-full(){
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '{ print $1 $2 }'| grep -E "energy-full:"
}

energy-full-design(){
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '{ print $1 $2 }'| grep -E "energy-full-design:"
}

date_(){
    echo "date: $(date +%Y-%m-%d)"
}

time_(){
    echo "time: $(date +"%H:%M")"
}

imp_files(){
    for files in .bat_info.txt
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
            touch $HOME/$files
        fi

  done
}
imp_files
echo "--------------------------" >> .bat_info.txt
date_ >> .bat_info.txt
time_ >> .bat_info.txt
energy-full >> .bat_info.txt
energy-full-design >> .bat_info.txt
