#!/bin/sh
brightnessctl -m | awk -F, '{gsub(/%/,"",$4); print $4}'

