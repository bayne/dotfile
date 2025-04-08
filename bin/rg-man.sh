#!/bin/bash
if [[ -z $1 ]]; then
  echo "missing required";
  exit 1
fi
rg --color=always -C2 $1 /usr/share/man-txt | less
