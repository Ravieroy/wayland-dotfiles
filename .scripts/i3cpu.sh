#!/bin/sh

case $BLOCK_BUTTON in
 1) notify-send "Biggest CPU  Hogs :
 $(ps axch -o cmd:15,%cpu --sort=-%cpu | head)" ;;
 3) echo 'Load Average ' ;;
esac

uptime | awk -F'load average:' '{ print $2 }'

