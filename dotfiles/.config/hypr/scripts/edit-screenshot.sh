#!/bin/bash

# --- 高级截图脚本 ---
# 功能: 1. 保存到文件, 2. 复制到剪贴板, 3. 在 Swappy 中打开编辑

# --- 配置 ---
SAVE_DIR="$HOME/Pictures/Screenshots"

# --- 准备工作 ---
# 确保保存目录存在
mkdir -p "$SAVE_DIR"
# 动态生成文件名
FILE_NAME="$(date +'%Y-%m-%d-%H%M%S.png')"
SAVE_PATH="$SAVE_DIR/$FILE_NAME"

# --- 核心逻辑 ---
# 1. 让用户选择区域。如果用户按 Esc 取消，则退出脚本。
SELECTION=$(slurp)
if [ -z "$SELECTION" ]; then
    exit 0
fi

# 2. 运行 grim 捕捉选区，并将输出通过管道传给 tee
grim -g "$SELECTION" - | tee "$SAVE_PATH" >(wl-copy) | swappy -f - -o $SAVE_PATH

notify-send "截图复制到剪贴板，编辑后文件保存至~/Pictures。"