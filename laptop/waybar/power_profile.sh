#!/usr/bin/env bash

# If called with "next" or "toggle", cycle to the next profile
if [ "$1" = "next" ] || [ "$1" = "toggle" ]; then
    current=$(powerprofilesctl get 2>/dev/null)
    # Available profiles dynamically from powerprofilesctl list
    all_available=$(powerprofilesctl list 2>/dev/null | awk -F: '/^[ *]{2}[a-z-]+:/{gsub(/[ *]/, "", $1); print $1}')

    # Desired order: power-saver -> balanced -> performance
    order=("power-saver" "balanced" "performance")
    profiles=()
    for p in "${order[@]}"; do
        if echo "$all_available" | grep -qx "$p"; then
            profiles+=("$p")
        fi
    done

    # Add any other profile that might exist
    while IFS= read -r p; do
        if [ -n "$p" ] && [[ ! " ${profiles[*]} " =~ " ${p} " ]]; then
            profiles+=("$p")
        fi
    done <<< "$all_available"

    # Fallback if list empty
    if [ ${#profiles[@]} -eq 0 ]; then
        profiles=("power-saver" "balanced" "performance")
    fi

    # Find current profile index and cycle
    next_profile=""
    for i in "${!profiles[@]}"; do
        if [ "${profiles[$i]}" = "$current" ]; then
            next_idx=$(( (i + 1) % ${#profiles[@]} ))
            next_profile="${profiles[$next_idx]}"
            break
        fi
    done

    if [ -z "$next_profile" ]; then
        next_profile="${profiles[0]}"
    fi

    powerprofilesctl set "$next_profile"
    pkill -RTMIN+8 waybar 2>/dev/null
    exit 0
fi

# Current profile mapped to progress bar glyphs:
# saver       -> empty:     nf-extra-progress_empty_left + nf-extra-progress_empty_right (U+EE00 U+EE02)
# balanced    -> half full: nf-extra-progress_full_left  + nf-extra-progress_empty_right (U+EE03 U+EE02)
# performance -> full:      nf-extra-progress_full_left  + nf-extra-progress_full_right  (U+EE03 U+EE05)
current=$(powerprofilesctl get 2>/dev/null)
case "$current" in
    "power-saver")
        icon="\uee00\uee02"
        ;;
    "balanced")
        icon="\uee03\uee02"
        ;;
    "performance")
        icon="\uee03\uee05"
        ;;
    *)
        icon="\uee00\uee02"
        ;;
esac

printf '{"text":"%b","tooltip":"Power Profile: %s","class":"%s"}\n' "$icon" "$current" "$current"
