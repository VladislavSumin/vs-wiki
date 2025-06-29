#!/bin/bash
# Скрипт для обновления конфигурации домашней директории
SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cp -R "$SCRIPT_DIR/home/." ~/
