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

#Check if sender is friends with reciever
if ! grep -w "$1" ./"$2"/friends.txt > /dev/null && [ ! "$1" = "$2" ]; then
	#User is not friends with reciever
	echo nok: User "$1" is not a friend of "$2"
	exit 1
fi

#Send message to second user's wall from user 1
echo Message sent!
echo "$1": "$3" >> ./"$2"/wall.txt

