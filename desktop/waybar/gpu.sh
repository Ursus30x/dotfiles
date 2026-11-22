#!/usr/bin/env bash

if ! command -v nvidia-smi >/dev/null 2>&1; then
    echo '{"text":"N/A  󰢮","tooltip":"nvidia-smi not found","class":"error"}'
    exit 0
fi

query=$(nvidia-smi --query-gpu=name,utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | head -n 1)

if [ -z "$query" ]; then
    echo '{"text":"N/A  󰢮","tooltip":"Failed to query GPU","class":"error"}'
    exit 0
fi

IFS=',' read -r name util temp mem_used mem_total <<< "$query"

# Trim whitespace
name="${name#"${name%%[![:space:]]*}"}"
name="${name%"${name##*[![:space:]]}"}"
util="${util// /}"
temp="${temp// /}"
temp="${temp%%.*}"
mem_used="${mem_used// /}"
mem_total="${mem_total// /}"

printf '{"text":"%s%%  󰢮","tooltip":"%s\\nUtilization: %s%%\\nTemperature: %s°C\\nVRAM: %s / %s MiB","class":"gpu"}\n' \
    "$util" "$name" "$util" "$temp" "$mem_used" "$mem_total"
