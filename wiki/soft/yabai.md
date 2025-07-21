# yabai

Менеджер окон для MacOS

* [git](https://github.com/koekeishiya/yabai)

## Полезные команды
Получить список всех окон
```shell
yabai -m query --windows
```

## Отключение защиты ядра

[wiki](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)

Проверить состояние защиты:

```shell
csrutil status
```

Что бы выключить защиту нужно загрузится в режиме восстановления (долго держим кнопку питания),
потом утилиты, в верхнем меню терминал.

```shell
csrutil enable --without fs --without debug --without nvram
```

Потом после перезагрузки:

```shell
sudo nvram boot-args=-arm64e_preview_abi
```

И потом обязательно еще раз перезагрузить.

## Установка

[wiki](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release))

```shell
brew install koekeishiya/formulae/yabai
yabai --start-service
sudo yabai --load-sa
```