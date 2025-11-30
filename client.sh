#!/bin/bash

#Checks if the user entered a valid username, creates the user if needed
if [ -z "$1" ]; then
	echo "[ERROR]: Usage: client.sh <username>"
	exit
else
	client="$1"
	
	if [ -d "$client" ]; then
		echo "[SUCCESS]: Welcome back, $client!"
	else
		echo "[SUCCESS]: Welcome! User created!"
		./create.sh "$client";
	fi
fi
client_pipe="${client}.pipe"
server_pipe="server.pipe"

# Creates the client pipe
if [[ ! -p "$client_pipe" ]]; then
	rm -f "$client_pipe"
    mkfifo "$client_pipe" 
fi

# Until user exits with CTRL+C, loop
(
    while true; do
        if read -r response < "$client_pipe"; then
            echo "$response"
        fi
    done
) &
while true; do
	echo -----------------------------------
	echo Options: add, post, display
	read -p "--> " cmd usr msg


	case "$cmd" in
		add)
			if [ -z "$usr" ]; then
				echo "[ERROR]: Usage: add <username>"
			else
				if [ -d "$usr" ]; then
					echo "$client add $usr" > "$server_pipe"
				else
					echo "[ERROR]: Cannot add. $usr doesn't exist!"
				fi
			fi
			;;
		post)
			if [ -z "$usr" ] || [ -z "$msg" ]; then
				echo "[ERROR]: Usage: post <username> <message>"
			else
				if [ -d "$usr" ]; then
					echo "$client post $usr $msg" > "$server_pipe"
				else
					echo "[ERROR]: $usr doesn't exist!"
				fi
			fi
			;;
		display)
			if [ -z "$usr" ]; then
				echo "[ERROR]: Usage: display <username>"
			else
				if [ -d "$usr" ]; then
					echo "$client display $usr" > "$server_pipe"
				else
					echo "[ERROR]: $usr doesn't exist!"
				fi
			fi
			;;
		*)
			echo "[ERROR]: Invalid command"
			;;
	esac
    #Gives time for background process
    sleep 1
done
rm -f "$client_pipe"
