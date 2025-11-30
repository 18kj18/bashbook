#!/bin/bash

#Check if user exists
if ! ls | grep -w "$1" > /dev/null; then
	#User does not exist
	echo nok: User "$1" does not exist
else
	case "$2" in
		friends)
			#Print friends list
			echo "$1's Friends--"	
			cat "$1"/friends.txt
			;;
		wall)
			#Print wall	
			echo "$1'"s Wall--
			cat "$1"/wall.txt
			;;
		*)
			#Invalid input
			echo "Usage: display <username> <friends | wall>"
	esac
fi
