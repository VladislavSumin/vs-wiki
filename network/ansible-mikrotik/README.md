# Ansible mikrotik

Запускаем командой:

```shell
ansible-playbook ./mikrotik.yml
```

### Исправление ошибок

Если стреляет ошибка:

```
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: ModuleNotFoundError: No module named 'librouteros'
```

То пробуем установить библиотеку:

```
pip3 install librouteros
```

Если продолжает стрелять, то пробуем явно указать интерпретатор питона:

```shell
ansible-playbook ./mikrotik.yml -e 'ansible_python_interpreter=/usr/bin/python3'
```
