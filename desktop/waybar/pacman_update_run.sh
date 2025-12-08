#!/usr/bin/env bash

kitty -e bash -c '
echo -e "Performing system update (pacman -Syu)\n"
sudo pacman -Syu
'
