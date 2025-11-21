#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <target_dir>"
    exit 1
fi

TARGET_DIR="./$1"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR does not exist"
    exit 1
fi

for d in "$TARGET_DIR"/*/; do
    name=$(basename "$d")
    if [ -d "$HOME/.config/$name" ]; then
        rm -rf "$TARGET_DIR/$name"
        cp -r "$HOME/.config/$name" "$TARGET_DIR/"
    fi
done
