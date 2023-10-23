#!/usr/bin/env bash

# struggling with this script, will need more attention
# need to convert the output of awk to a percentage
# for values 0 - 3, 0 being off and 3 being fullbright

msgId="123456"

if [[ $1 == "up" ]]; then
asusctl -n
else
asusctl -p
fi

kbdbright="$(asusctl -k | awk '/^Current/ {print$5}')"

dunstify -a "changeKBDBrightness" -r "$msgId" -h int:value:"$kbdbright" "Keyboard: ${kbdbright}%"