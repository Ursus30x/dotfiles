#!/usr/bin/env bash

# make sure pacman-contrib is installed
if ! command -v checkupdates >/dev/null 2>&1; then
  echo '{"text":"error","tooltip":"checkupdates command not found"}'
  exit 0
fi

updates=$(checkupdates 2>/dev/null)
code=$?

# exit code 2 → no updates
if [ $code -eq 2 ]; then
  echo '{"text":"no package updates","tooltip":"System up to date"}'
  exit 0
fi

# exit code 1 → error
if [ $code -eq 1 ]; then
  echo '{"text":"error","tooltip":"checkupdates failed"}'
  exit 0
fi

# exit code 0 → updates available
# escape characters for JSON
tooltip=$(printf "%s" "$updates" \
    | sed 's/\\/\\\\/g; s/"/\\"/g; :a;N;$!ba;s/\n/\\n/g')

echo "{\"text\":\"new package updates\",\"tooltip\":\"$tooltip\"}"
