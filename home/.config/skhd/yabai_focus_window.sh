#!/bin/bash

# Этот скрипт ищет окно, приложение и заголовок которого соответствуют заданным параметрам,
# и фокусирует его с помощью yabai.
#
# Использование: $0 <app-name> <title-regex>
#
# Пример: $0 "Firefox" "\\(vpn\\)"

if [ $# -ne 2 ]; then
    echo "Usage: $0 <app-name> <title-regex>"
    exit 1
fi

app_name="$1"
title_regex="$2"

window_id=$(yabai -m query --windows | jq -r --arg app "$app_name" --arg re "$title_regex" '.[] | select(.app == $app) | select(.title | test($re)) | .id' | head -n 1)

if [ -n "$window_id" ]; then
    yabai -m window --focus "$window_id"
fi