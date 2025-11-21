#!/bin/bash

#Check if username was given
if [ -z "$1" ]; then
	echo nok: No username entered
else 
	#Check if user exists
	if ls | grep -w $1 > /dev/null; then
		#User already exists
		echo nok: User already exists
	else
	
		#User doesn't exist
		mkdir ./$1
		touch ./$1/friends.txt
		touch ./$1/wall.txt
		echo ok: User $1 created
	fi
fi
