#!/bin/bash

#Check if first user exists
if ! ls | grep -w "$1" > /dev/null; then
	#User does not exist
	echo nok: User "$1" does not exist
	exit 1
fi

#Check if second user exists
if ! ls | grep -w "$2" > /dev/null; then
	#User does not exist
	echo nok: User "$2" does not exist
	exit 1
fi

#Check if user 2 is already a friend of user 1
if grep -w "$2" ./"$1"/friends.txt > /dev/null; then
	#Users are already friends
	echo ok: Friend already added!
	exit 0
else
	echo "$2" >> ./"$1"/friends.txt
	echo ok: Friend added!
	exit 0
fi
