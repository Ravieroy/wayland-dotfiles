#!/bin/bash
if [ -z $(hostname -I | awk '{print $1}') ]
    then
		echo "No Internet"
else
	UPDATES=`dnf check-update -q | awk '{print $1}'`
	COUNT=`printf "%s\n" "$UPDATES" | grep -v "^$" | wc -l`
	DNF=`printf "%s\n" "$UPDATES" | grep -v "^$" | grep dnf`

	if [ $COUNT -gt 0 ]; then
		echo "$COUNT updates"
	else
		echo "0"
	fi
fi


