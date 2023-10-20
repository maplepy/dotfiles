#!/bin/bash
# autostart.sh
# by maplepy

run_if_not_running() {
    if ! pgrep -f $1 ;
    then
        $@&
    else
        notify-send "autostart" "$1 is already running"
    fi
}

# run_if_not_running picom -b
