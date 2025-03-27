#!/bin/bash
scrot /tmp/screen.png
ffmpeg -y -i /tmp/screen.png -vf "gblur=sigma=32" /tmp/screen_blur.png
rm /tmp/screen.png
i3lock -i /tmp/screen_blur.png && systemctl suspend
rm /tmp/screen_blur.png