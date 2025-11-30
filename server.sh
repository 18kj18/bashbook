#!/bin/bash

server_pipe="server.pipe"

# Make the server pipe
if [[ ! -p "$server_pipe" ]]; then
    rm -f "$server_pipe"
    mkfifo "$server_pipe"
fi

echo Server Started----------
while true; do

    
    if IFS=' ' read -r client cmd usr msg < "$server_pipe"; then


        client_pipe="${client}.pipe"

        # Ensure the client pipe exists
        if [[ ! -p "$client_pipe" ]]; then
            echo "ERROR: Pipe for client '$client' does not exist"
            continue
        fi

        case "$cmd" in
            add)
                sh ./add_friend.sh "$client" "$usr" > "$client_pipe"
                ;;
            post)
                sh ./post_message.sh "$client" "$usr" "$msg" > "$client_pipe"
                ;;
            display)
                sh ./display_wall.sh "$usr" > "$client_pipe"
                ;;
            *)
                echo "Invalid command '$cmd'" > "$client_pipe"
                ;;
        esac

    fi

done 