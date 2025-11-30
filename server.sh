#!/bin/bash

# Handles clients asynchronously
handle_client () {
	local client="$1"
	local cmd="$2"
	local usr="$3"
	local msg="$4"
	
	echo "Handling $1 $2 $3 $4"

	 case "$cmd" in
            add)
                sh ./acquire.sh "add"
		sh ./add_friend.sh "$client" "$usr" > "$client.pipe"
                sh ./release.sh "add"
		;;
            post)
		sh ./acquire.sh "post"
                sh ./post_message.sh "$client" "$usr" "$msg" > "$client.pipe"
                sh ./release.sh "post"
		;;
            display)
                sh ./display_wall.sh "$usr" "$msg" > "$client.pipe"
		;;
	    search)
		sh ./search.sh "$usr" > "$client.pipe"
		;;
            *)
                echo "Invalid command '$cmd'" > "$client.pipe"
                ;;
        esac
	echo "Sent output to $client.pipe"
}
	
server_pipe="server.pipe"

# Make the server pipe
if [[ ! -p "$server_pipe" ]]; then
    rm -f "$server_pipe"
    mkfifo "$server_pipe"
fi

echo Server Started----------
while true; do
    if IFS=' ' read -r global_client global_cmd global_usr global_msg < "$server_pipe"; then

        # Ensure the client pipe exists
        if [[ ! -p "$global_client.pipe" ]]; then
            echo "ERROR: Pipe for client '$global_client' does not exist"
        else
	    
	    handle_client "$global_client" "$global_cmd" "$global_usr" "$global_msg" &
        fi
    fi

done
