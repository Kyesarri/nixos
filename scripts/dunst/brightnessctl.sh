#!/usr/bin/env bash

msgId="42069"

if [[ $1 == "up" ]]; then
brightnessctl set 2%+
else
brightnessctl set 2%-
fi

brightness="$(brightnessctl -m | awk -F ',' '{ print $4 }')"

dunstify -a "changeBrightness" -i redeyes -r "$msgId" -h int:value:"$brightness" "DSP: ${brightness}"