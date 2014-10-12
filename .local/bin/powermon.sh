#!/bin/sh
# This is a pretty simple script to poll the system status and run some simple
# power management scripts. There may be a better way to do this (systemd), but 
# Ubuntu doesn't seem to want to make it easy.

# blank screen after 10 minutes
xset s 600 600

# suspend after 20 minutes of inactivity if not plugged in
# Note: what we really want: lock after 10 minutes, suspend after 20 minutes if
# not plugged in, or if plugged in and then unplugged after 10 minutes more...
xautolock -time 10 -locker "laptop-lock" -killtime 10 -killer "on_ac_power || laptop-suspend" -secure &

while [ 0 = 0 ]; do
    LID_STATE="$(perl -ane 'print "$F[-1]\n";' /proc/acpi/button/lid/LID/state)"
    if [ "${LID_STATE}" = "closed" ]; then
        laptop-suspend
    fi
    sleep 5
done
