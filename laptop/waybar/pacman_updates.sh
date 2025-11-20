#!/usr/bin/env bash

# check internet connection first
if ! ping -c1 -W1 8.8.8.8 >/dev/null 2>&1; then
  echo '{"text":"no internet","tooltip":"No internet connection"}'
  exit 0
fi

# make sure pacman-contrib is installed
if ! command -v checkupdates >/dev/null 2>&1; then
  echo '{"text":"error","tooltip":"checkupdates command not found"}'
  exit 0
fi

updates=$(checkupdates 2>/dev/null)
code=$?

# exit code 2 → no updates
if [ $code -eq 2 ]; then
  echo '{"text":" all packages up to date","tooltip":"System up to date"}'
  exit 0
fi

# exit code 1 → error
if [ $code -eq 1 ]; then
  echo '{"text":"error","tooltip":"checkupdates failed"}'
  exit 0
fi

# exit code 0 → updates available
tooltip=$(printf "%s" "$updates" \
    | sed 's/\\/\\\\/g; s/"/\\"/g; :a;N;$!ba;s/\n/\\n/g')

echo "{\"text\":\"updates available\",\"tooltip\":\"$tooltip\"}"
