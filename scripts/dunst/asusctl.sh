#!/usr/bin/env bash

msgId="123456"

if [[ $1 == "up" ]]; then
asusctl -n
else
asusctl -p
fi

brightnesslvl="$(asusctl -k | awk '/^Current/ {print ($5)}')" # print 5th line

# kbdbright="$(asusctl -k | awk '/^Current/ {print ($5*33)}')"
# close enough :D
# dunstify -a "changeKBDBrightness" -r "$msgId" -h int:value:"$kbdbright" "Keyboard: ${kbdbright}%"

dunstify -a "changeKBDBrightness" -r "$msgId" -h value: "KBD - ${brightnesslvl}"

# value:"$kbdbright" "Keyboard: ${kbdbright}%"
