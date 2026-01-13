#!/usr/bin/env -S uv run --cache-dir=/home/bpayne/.uv-cache --script
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "requests",
# ]
# ///
import json
import os
import sys
import subprocess
from urllib.parse import urlparse

import requests

BOOKMARKS_FILE = "/home/bpayne/.config/google-chrome/Default/Bookmarks"
ICON_DIR = "/home/bpayne/Code/mine/dotfile/icons"
BOOKMARKS_FOLDER_NAME = "rofi"
CHROME_EXEC = f"/usr/bin/google-chrome"

def get_icon(url):
    hostname = urlparse(url).hostname
    domain = '.'.join(hostname.split('.')[-2:])
    path = f'{ICON_DIR}/{domain}.ico'
    if os.path.exists(path):
        return path

    resp = requests.get(f'https://icons.duckduckgo.com/ip3/{domain}.ico', timeout=0.2)
    with open(path, 'wb') as f:
        f.write(resp.content)
    return path

options = []
with open(BOOKMARKS_FILE) as f:
    j = json.load(f)
    for child in j['roots']['bookmark_bar']['children']:
        if child['name'] == BOOKMARKS_FOLDER_NAME:
            for bookmark in child['children']:
                icon_path = get_icon(bookmark['url'])
                options.append(f"    {bookmark['name']}\t{bookmark['url']}\0icon\x1f{icon_path}")

if len(sys.argv) > 1:
    selected = sys.argv[1]
    selected_url = None
    for option in options:
        if option.startswith(selected):
            selected_url = option.split("\0")[0].split("\t")[1]
            break

    if selected_url:
        subprocess.Popen(
            [
                CHROME_EXEC,
                "--new-window",
                selected_url
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
else:
    print("\n".join(options))
