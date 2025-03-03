#!/usr/bin/python3
import os
import tarfile
import requests
from pathlib import Path
from tqdm import tqdm

response = requests.get("https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=release")
response.raise_for_status()
url = response.json()['IIU'][0]['downloads']['linux']['link']
filename = url.split('/')[-1]
intellij_dir = '/home/bpayne/IntelliJ'
file_path = f'{intellij_dir}/{filename}'

response = requests.get(url, stream=True)
response.raise_for_status()

total_size = int(response.headers.get("content-length", 0))
chunk_size = 8192

if not os.path.exists(file_path):
    with open(file_path, "wb") as file, tqdm(total=total_size, unit="B", unit_scale=True, desc=file_path) as progress_bar:
        for chunk in response.iter_content(chunk_size=chunk_size):
            file.write(chunk)
            progress_bar.update(len(chunk))
    print(f"File downloaded: {file_path}")
else:
    print(f"File already downloaded: {file_path}, skipping")
