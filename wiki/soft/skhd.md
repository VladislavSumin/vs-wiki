# skhd

Демон для биндинга хоткеев на MacOs. По мимо биндинга хоткеев так же умеет эмулировать пользовательский ввод.

[git](https://github.com/koekeishiya/skhd)

## Установка и запуск

```bash
brew install koekeishiya/formulae/skhd
```

```bash
skhd --start-service
```

## Конфигурация

Порядок поиска конфигурации:

```
$XDG_CONFIG_HOME/skhd/skhdrc
$HOME/.config/skhd/skhdrc
$HOME/.skhdrc
```
