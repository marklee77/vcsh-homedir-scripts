#!/bin/sh
BATTERY_WARN_MINUTES=10
BATTERY_HIBERNATE_MINUTES=3

# This is a pretty simple script to poll the system status and run some simple
# power management scripts. There may be a better way to do this (systemd), but 
# Ubuntu doesn't seem to want to make it easy.

# blank screen after 10 minutes
xset s 600 600

# suspend after 20 minutes of inactivity if not plugged in
# Note: what we really want: lock after 10 minutes, suspend after 20 minutes if
# not plugged in, or if plugged in and then unplugged after 10 minutes more...
xautolock -time 10 -locker laptop-lock -killtime 10 -killer "on_ac_power || laptop-suspend" -secure &

BATTERY_STATUS=ok
while [ 0 = 0 ]; do

    LID_STATE="$(perl -ane 'print "$F[-1]\n";' /proc/acpi/button/lid/LID/state)"
    if [ "${LID_STATE}" = "closed" ]; then
        laptop-suspend
    fi

    BATTERY_REMAINING_CAPACITY=$(perl -ane 'print "$F[2]\n" if (/^remaining capacity:/);' /proc/acpi/battery/BAT0/state)
    BATTERY_PRESENT_RATE=$(perl -ane 'print "$F[2]\n" if (/^present rate:/);' /proc/acpi/battery/BAT0/state)
    BATTERY_MINUTES_REMAINING=$((${BATTERY_REMAINING_CAPACITY}*60/${BATTERY_PRESENT_RATE}))

    if on_ac_power; then
        BATTERY_STATUS=ok
    else
        if [ "${BATTERY_STATUS}" = "ok" ] &&
           [ "${BATTERY_MINUTES_REMAINING}" -lt "${BATTERY_WARN_MINUTES}" ]; 
        then
            BATTERY_STATUS=low
            notify-send --urgency=critical "Low Battery Warning!" "The remaining battery charge is critically low. If AC power is not restored then shortly it will be necessary to hibernate or shut down."
        elif [ "${BATTERY_STATUS}" = "low" ] &&
             [ "${BATTERY_MINUTES_REMAINING}" -lt "${BATTERY_HIBERNATE_MINUTES}" ]; then
            BATTERY_STATUS=critical
            notify-send --urgency=critical "Hibernating!" "If the computer is not plugged in within the next 30 seconds, hibernation procedures will commence."
            sleep 30
            if ! on_ac_power; then
                laptop-hibernate
            fi
        fi
    fi

    # Let's not use all of the CPU cycles on power management...
    sleep 5

done
