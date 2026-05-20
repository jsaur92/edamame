#!/bin/sh
printf '\033c\033]0;%s\a' Edu Game Maker
base_path="$(dirname "$(realpath "$0")")"
"$base_path/edugame.x86_64" "$@"
