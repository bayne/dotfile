#!/bin/sh
xrandr --newmode "5120x1440_60.00"  624.50  5120 5496 6048 6976  1440 1443 1453 1493 -hsync +vsync
xrandr --addmode Virtual-1 5120x1440_60.00
xrandr --output Virtual-1 --primary --mode 5120x1440_60.00 --pos 0x0 --rotate normal --output Virtual-2 --mode 1920x1080 --pos 0x1440 --rotate normal
