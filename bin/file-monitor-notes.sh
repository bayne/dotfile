#!/bin/bash

DIR_TO_WATCH="/home/bpayne"
NOTES_DIR="/home/bpayne/Code/mine/notes"

EXTENSION="(dcb|ntxt)"

pushd $NOTES_DIR
inotifywait -m -r -e delete -e close_write --format '%w %f' --include ".*\.$EXTENSION$" "$DIR_TO_WATCH" \
| while read SOURCE_DIR SOURCE_FILE
do
  echo $SOURCE_DIR
  DEST_DIR="$NOTES_DIR/$(hostname)/$SOURCE_DIR"
  mkdir -p $DEST_DIR && \
  rsync -av --delete --include "*.dcb" --include "*.ntxt" --exclude "*" $SOURCE_DIR $DEST_DIR
  git add .
  git commit -m "Sync $SOURCE_DIR $SOURCE_FILE" && \
  git push origin master
done

