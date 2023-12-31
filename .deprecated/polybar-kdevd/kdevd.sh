#!/bin/sh
### Configuration
accentColor="#ff6376"
separator="|"
useDesktopNames=true
###

checkForDesktopName() {
    if [[ $useDesktopNames = true ]]; then
        desktopLabel=$(wmctrl -d | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9="";print}' | sed 's/^[[:space:]]*//' | sed -n -e "${i}"p)
    else
        desktopLabel=$i
    fi
}

while true; do
    numberOfDesktops=$(wmctrl -d | wc -l)
    moduleText=""
    desktopLabel=""
    for i in $(seq 1 "$numberOfDesktops"); do
        s=$separator
        if [[ $i = "$numberOfDesktops" ]]; then
            s=""
        fi

        checkForDesktopName
        if [[ $i = $(qdbus org.kde.KWin /KWin currentDesktop) ]]; then
            moduleText+="%{F$accentColor}$desktopLabel%{F-} $s "
        else
            moduleText+=$desktopLabel" $s "
        fi
    done

    echo "$moduleText"
done

