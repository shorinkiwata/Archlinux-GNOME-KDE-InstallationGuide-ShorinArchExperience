#!/bin/bash

# 检查蓝牙的 rfkill 状态
# 'rfkill list bluetooth' 会输出蓝牙设备的信息
# 'grep -q "Soft blocked: yes"' 在输出中安静地 (-q) 查找 "Soft blocked: yes" 字符串

if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    # 如果找到了 "Soft blocked: yes" (说明蓝牙被软屏蔽了)
    # 则执行 unblock 命令来解锁
    rfkill unblock bluetooth
    # (可选) 发送一个通知，提供操作反馈
    notify-send -a "Bluetooth" "Bluetooth Unblocked" "蓝牙射频已开启" -i bluetooth-active
else
    # 如果没有找到 "Soft blocked: yes" (说明蓝牙是开启的)
    # 则执行 block 命令来屏蔽
    rfkill block bluetooth
    # (可选) 发送通知
    notify-send -a "Bluetooth" "Bluetooth Blocked" "蓝牙射频已关闭" -i bluetooth-disabled
fi