#!/bin/python3

"""
Update ~/.config/dunst/dunstrc with

```python
[default]
script = /path/to/dunst-share.py
```
"""
import json
import sys


DUNST_SHARE_FILE = '/mnt/share/dunst-share.jsonl'
_, appname, summary, body, icon, urgency = sys.argv
notification = {
    'appname': appname,
    'summary': summary,
    'body': body,
    'icon': icon,
    'urgency': urgency
}
with open(DUNST_SHARE_FILE, 'a') as f:
    f.write(json.dumps(notification) + "\n")