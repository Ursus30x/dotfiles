#!/bin/sh
val=$(cat /sys/class/power_supply/BAT0/power_now)
echo "$(awk "BEGIN { printf \"%.2f\", $val/1000000 }")"
