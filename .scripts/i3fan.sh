#!/bin/bash 

sensors |grep -i fan | awk '{ gsub(/[ ]+/," "); print $2 " " $3 }'
