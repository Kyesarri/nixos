#!/usr/bin/env bash

msgId="123456"

if [[ $1 == "up" ]]; then
asusctl -n
else
asusctl -p
fi

# awk scans output looks for the string after '/^Current/ $ is the column to print $5 being the 5th
# brightnesslvl="$(asusctl -k | awk '/^Current/ {print ($5)}')" # print 5th line

# dunstify -a "changeKBDBrightness" -i lighttable -r "$msgId" -h value: "KBD - ${brightnesslvl}"

# value:"$kbdbright" "Keyboard: ${kbdbright}%"

# config
# enabledgpu=$(supergfxctl -g)                                                    # active gpu
# boardmodel=$(asusctl -v | awk '/^Board/ {print$3}')                             # motherboard revision, don't like the white space left of Board
# platformprofile=$(asusctl profile --profile-get | awk '/^Active/ {print$4}')    # current profile, assuming this is power related