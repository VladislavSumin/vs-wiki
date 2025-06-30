#!/bin/bash

# Этот скрипт ищет окно, приложение и заголовок которого соответствуют заданным параметрам,
# и фокусирует его с помощью yabai.
#
# Использование: $0 <app-regex> [title-regex]
#
# Пример 1: $0 "^Firefox$"
# Пример 2: $0 "^Firefox$" "\\(vpn\\)"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <app-regex> [title-regex]"
    exit 1
fi

app_regex="$1"
title_regex="${2:-}"

if [ -z "$title_regex" ]; then
    window_id=$(yabai -m query --windows | jq -r --arg app "$app_regex" '.[] | select(.app | test($app)) | .id' | head -n 1)
else
    window_id=$(yabai -m query --windows | jq -r --arg app "$app_regex" --arg re "$title_regex" '.[] | select(.app | test($app)) | select(.title | test($re)) | .id' | head -n 1)
fi

if [ -n "$window_id" ]; then
    yabai -m window --focus "$window_id"
fi