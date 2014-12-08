#! /usr/bin/bash
TIME=$(date +%Y%m%d%H%M%S)
PUB=~/projects/bayne.github.io/static/images
sleep 1
scrot -s -q 100 $PUB/$TIME.jpg
sleep 1
echo "![image](/images/$TIME.jpg)" | xclip -sel clip
exit 0
