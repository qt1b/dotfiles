#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash

# one liner from https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cp "$SCRIPT_DIR"/config/* ~/.config
cp "$SCRIPT_DIR"/home/* ~

# cp "$SCRIPT_DIR"/nixos/* /etc/nixos
