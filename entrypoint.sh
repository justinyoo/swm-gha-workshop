#!/bin/bash

set -e

# Usage function
function usage() {
    cat <<USAGE

    Usage: $0 [-k|--api-key Webex API key] [-r|--room-id Webex Room ID] [-t|--text text body] [-m|--markdown markdown body] [-h|--help]

    Options:
        -k|--api-key:    Webex API key.
        -r|--room-id:    Webex Room ID.
        -t|--text:       Message body in plain text.
        -m|--markdown:   Message body in markdown. It takes precedence over -t|--text.

        -h|--help:       Show this message.

USAGE

    exit 1
}

# Set up arguments
webex_token=""
webex_room_id=""
body_text=""
body_markdown=""

if [[ $# -eq 0 ]]; then
    webex_token=""
    webex_room_id=""
    body_text=""
    body_markdown=""
fi

while [[ "$1" != "" ]]; do
    case $1 in
    -k | --api-key)
        shift
        webex_token=$1
        ;;

    -r | --room-id)
        shift
        webex_room_id=$1
        ;;

    -t | --text)
        shift
        body_text=$1
        ;;

    -m | --markdown)
        shift
        body_markdown=$1
        ;;

    -h | --help)
        usage
        exit 1
        ;;

    *)
        usage
        exit 1
        ;;
    esac

    shift
done

if [[ $webex_token == "" ]]; then
    echo "Webex API Key not found"
    usage

    exit 1
elif [[ $webex_room_id == "" ]]; then
    echo "Webex Room ID not found"
    usage

    exit 1
elif [[ $body_text == "" ]] && [[ $body_markdown == "" ]]; then
    echo "Either text or markdown value must be provided"
    usage

    exit 1
fi

json_template='{"roomId":"%s","text":"%s","markdown":"%s"}\n'
json_body=$(printf "$json_template" "$webex_room_id" "$body_text" "$body_markdown")

# Send message
response=$(curl --location --request POST 'https://webexapis.com/v1/messages' \
    --header "Authorization: Bearer $webex_token" \
    --header "Content-Type: application/json" \
    --data "$json_body")

echo "::set-output name=response::$response"
