#!/bin/bash

# Обработка аргументов командной строки
HOSTS_FILE="$1"
BACKUP_DIR="$2"

# Проверка наличия обязательных аргументов
if [ -z "$HOSTS_FILE" ] || [ -z "$BACKUP_DIR" ]; then
  echo "Использование: $0 <hosts_file> <backup_directory>"
  exit 1
fi

# Получаем текущую дату в формате год-месяц-день
DATE=$(date +%Y-%m-%d)

# Создаем папку для бэкапов с датой
BACKUP_PATH="$BACKUP_DIR/$DATE"
mkdir -p "$BACKUP_PATH"

# Функция для подключения к Mikrotik, создания бэкапа и экспорта конфигурации
backup_mikrotik() {
  HOST=$1

  LOGIN=$(echo "$HOST" | cut -d'@' -f1)
  HOSTNAME=$(echo "$HOST" | cut -d'@' -f2)

  echo "Подключение к $HOSTNAME..."

  # Подключаемся к Mikrotik через SSH
  ssh "$LOGIN@$HOSTNAME" << EOF
    /system backup save name=backup.backup
    /export file=config.rsc
EOF

  if [ $? -eq 0 ]; then
    echo "Бэкап и экспорт конфигурации для $HOSTNAME успешно выполнены."

    # Копируем файлы с Mikrotik
    scp "$LOGIN@$HOSTNAME":backup.backup "$BACKUP_PATH/${HOSTNAME//./_}.backup" &&\
    scp "$LOGIN@$HOSTNAME":config.rsc "$BACKUP_PATH/${HOSTNAME//./_}.rsc"

    if [ $? -eq 0 ]; then
      echo "Файлы успешно скопированы с $HOSTNAME."
    else
      echo "Ошибка при копировании файлов с $HOSTNAME."
      return 1
    fi

  else
    echo "Ошибка при подключении к $HOSTNAME или выполнении команд."
    return 1
  fi
  return 0
}

if [[ ! -f "$HOSTS_FILE" ]]; then
  echo "Ошибка: Файл '$HOSTS_FILE' не существует."
  exit 1
fi

# Массив для хранения PID процессов
PIDS=()

# Чтение хостов из файла и запуск параллельного сбора бэкапов
while IFS= read -r HOST; do
  if [[ -n "$HOST" ]]; then # Проверка на пустую строку
    backup_mikrotik "$HOST" & # Запускаем бэкап каждого хоста в фоне
    PIDS+=($!) # Добавляем PID процесса в массив
  fi
done < "$HOSTS_FILE"

# Проверка на наличие ошибок
ERROR_COUNT=0
for pid in "${PIDS[@]}"; do
    if ! wait "$pid"; then # Проверяем код возврата каждого процесса
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
done

# Выход с кодом ошибки, если были ошибки при сборе бэкапов
if [ $ERROR_COUNT -gt 0 ]; then
  echo "Во время работы скрипта были ошибки, проверяйте логи!"
  exit 1
else
  echo "Бэкапы для всех хостов выполнены."
  exit 0
fi
