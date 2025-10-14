#!/bin/bash

grim -g "$(slurp)" - | tee $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S.png') >(wl-copy)

notify-send "截图成功复制到剪贴板，文件保存至~/Pictures。"