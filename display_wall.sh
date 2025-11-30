#!/bin/bash

#Check if user exists
if ! ls | grep -w "$1" > /dev/null; then
	#User does not exist
	echo nok: User "$1" does not exist
else
	#Print wall	
	echo "$1'"s Wall--
	cat ./"$1"/wall.txt
fi
