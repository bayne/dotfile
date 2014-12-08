#! /usr/bin/bash
# Change DBUSER to match your Dropbox UID. For more intstructions, see above.
DBUSER=1362057
TIME=$(date +%Y%m%d%H%M%S)
PUB=~/Dropbox/Public/Screenshots/
if [ -d $PUB ]
then
cd $PUB
else
mkdir $PUB
cd $PUB
fi
sleep 1
scrot -s -q 100 $TIME.jpg
sleep 1
LAST=$(find . -cmin -1 -iname "*.jpg" | tail -n 1 | sed 's!.*/!!')
URL1=http://dl.dropbox.com/u
URL2=Screenshots
echo "$URL1/$DBUSER/$URL2/$LAST" | xclip -sel clip
exit 0
