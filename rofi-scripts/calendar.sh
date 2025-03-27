#!/bin/bash
cat <(echo -en "\0markup-rows\x1ftrue") <(gcal -H '[:]:(:)' -b 2 `date +'%Y'` | sed 's/\[/<span background="#5555FF"> /g' | sed 's/\]/ <\/span>/g' | tail +5)