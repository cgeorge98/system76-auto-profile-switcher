#! /bin/sh

# -------This files are used to achieve auto power switching in pop os-------
# /sys/class/power_supply/BAT0/status
# /sys/class/power_supply/BAT0/capacity
# ---------------------------------------------------------------------------
second=60
discharging="Discharging"
charging="Charging"
full="Unknown"
limit=35 # minimum limit
while true; do
    status=$(cat /sys/class/power_supply/BAT0/status) || exit
    if [ "$status" = "$full" ]; then # if machine is full then switch to performance
        system76-power profile performance
    elif [ "$status" = "$charging" ]; then # if machine is on charging mode then, switch to performance or battery profile according to capacity
        capacity=$(cat /sys/class/power_supply/BAT0/capacity) || exit
        if [ "$capacity" -lt "$limit" ]; then # if battery capacity is less than 35 but its charging then, switch to battery profile
            system76-power profile balanced
        else # if battery capacity is more than 35 but its charging then, switch to performance profile
            system76-power profile performance
        fi
    elif [ "$status" = "$discharging" ]; then # if machine is on discharging mode then, switch to battery profile
        capacity=$(cat /sys/class/power_supply/BAT0/capacity) || exit
        if [ "$capacity" -lt "$limit" ]; then # if battery capacity is less than 35 and is not charging then, switch to battery profile
            system76-power profile battery
        else # if battery capacity is more than 35 and is not charging then, switch to balanced profile
            system76-power profile balanced
        fi
    fi
    sleep $second
done
