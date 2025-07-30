#!/bin/bash

# Скрипт для копирования публичного SSH ключа на Mikrotik RouterOS,
# аналогично утилите ssh-copy-id.
# Сгенерирован gemma-3-27b-it и допилен руками

# Проверка наличия необходимых инструментов
if ! command -v ssh &> /dev/null; then
  echo "Ошибка: Утилита 'ssh' не найдена."
  exit 1
fi

# Обработка аргументов командной строки
if [ $# -ne 1 ]; then
  echo "Использование: $0 <user>@<host>"
  echo "Пример: $0 admin@192.168.88.1"
  exit 1
fi

USER_HOST="$1"
USER=$(echo "$USER_HOST" | cut -d'@' -f1)
HOST=$(echo "$USER_HOST" | cut -d'@' -f2)

# Проверка доступности хоста
ping -c 1 "$HOST" &> /dev/null
if [ $? -ne 0 ]; then
  echo "Ошибка: Хост '$HOST' недоступен."
  exit 1
fi

# Поиск публичного ключа по умолчанию (~/.ssh/id_rsa.pub)
PUBLIC_KEY=$(find ~/.ssh -name "*.pub" | head -n 1)

if [ -z "$PUBLIC_KEY" ]; then
  echo "Ошибка: Публичный SSH ключ не найден в каталоге ~/.ssh."
  echo "Пожалуйста, убедитесь, что у вас есть публичный ключ (например, id_rsa.pub)."
  exit 1
fi

# Получение ключа из файла
KEY=$(cat "$PUBLIC_KEY")

# Команда для добавления ключа на Mikrotik
COMMAND="user/ssh-keys/add user=$USER key=\"$KEY\""

# Выполнение команды через SSH
ssh "$USER_HOST" "$COMMAND"

if [ $? -eq 0 ]; then
  echo "Успешно: Публичный ключ скопирован на '$HOST' для пользователя '$USER'."
else
  echo "Ошибка: Не удалось скопировать публичный ключ."
fi

exit 0
