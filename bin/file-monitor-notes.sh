#!/bin/bash
#
set -x

DIR_TO_WATCH="/home/bpayne"
NOTES_DIR="/home/bpayne/Documents/notes"

EXTENSION="(dcb|ntxt)"

inotifywait -m -r \
  -e delete \
  -e close_write \
  --format '%w %f' \
  --include ".*\.$EXTENSION$" \
  "$DIR_TO_WATCH" \
| while read SOURCE_DIR SOURCE_FILE
do
  set +x
  case "$SOURCE_DIR" in
    "$NOTES_DIR"/*)
      continue
      ;;
  esac
  pushd $NOTES_DIR
  set -x
  DEST_DIR="$NOTES_DIR/$(hostname)/$SOURCE_DIR"
  mkdir -p $DEST_DIR && \
  rsync -av --delete --include "*.dcb" --include "*.ntxt" --exclude "*" $SOURCE_DIR $DEST_DIR && \
  git add . && \
  git commit -m "Sync $SOURCE_DIR $SOURCE_FILE"
  git pull origin master && \
  git push origin master
  if [ $? -ne 0 ]; then
    if git ls-files -u | grep -q "^[^[:space:]]"; then
      notify-send -u critical "Notes sync failed" "conflicts detected"
    else
      notify-send -u critical "Notes sync failed" "other reason"
    fi
  fi
  popd
done

