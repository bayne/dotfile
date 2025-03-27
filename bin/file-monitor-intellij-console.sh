#!/bin/bash

FILE_TO_MONITOR=/home/bpayne/Code/Disney/workspace/output/console.txt
BACKUP_DIR=/home/bpayne/Code/Disney/workspace/output

echo $FILE_TO_MONITOR
echo $BACKUP_DIR

inotifywait -m -e close_write --format '%w%f' "$FILE_TO_MONITOR" | while read MODFILE
do
  TIMESTAMP=$(date +"%Y%m%d%H%M%S")
  echo "$MODFILE" "$BACKUP_DIR/$(basename $MODFILE)_$TIMESTAMP"
  cp "$MODFILE" "$BACKUP_DIR/$(basename $MODFILE)_$TIMESTAMP"
done
