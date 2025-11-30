#!/bin/bash

#Removes pipe when user exits program
trapper() {
	rm -f "$client_pipe"
	echo "Exiting... Goodbye!"
	exit 1
}

trap 'trapper' SIGINT

#Checks if the user entered a valid username, creates the user if needed
if [ -z "$1" ]; then
	echo "[ERROR]: Usage: client.sh <username>"
rm -f "$client_pipe"
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
while true; do
	echo -----------------------------------
	echo Options: add, post, display, search
	read -p "--> " cmd usr msg

	suc=0

	case "$cmd" in
		add)
			if [ -z "$usr" ]; then
				echo "[ERROR]: Usage: add <username>"
			else
				if [ -d "$usr" ]; then
					echo "$client add $usr" > "$server_pipe"
					suc=1
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
					suc=1
				else
					echo "[ERROR]: $usr doesn't exist!"
				fi
			fi
			;;
		display)
			if [ -z "$usr" ] || [ -z "$msg" ]; then
				echo "[ERROR]: Usage: display <username> <friends | wall>"
			else
				if [ -d "$usr" ]; then
					echo "$client display $usr" "$msg" > "$server_pipe"
					suc=1
				else
					echo "[ERROR]: $usr doesn't exist!"
				fi
			fi
			;;
		search)
			if [ -z "$usr" ]; then
				echo "[ERROR]: Usage: search <username>"
			else
				echo "$client search $usr" > "$server_pipe"
				suc=1
			fi
			;;
		*)
			echo "[ERROR]: Invalid command"
			;;
	esac

	#If we expect a response, retrieve it
	if [ "$suc" -eq 1 ]; then
		while IFS= read -r line; do
			echo "$line"
		done < "$client_pipe"
	fi
    	sleep 1
done
