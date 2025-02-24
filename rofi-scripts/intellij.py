#!/home/bpayne/Code/Github/pyenv/versions/rofi-scripts/bin/python

import os
import subprocess
import xml.etree.ElementTree as ET
from typing import List

USER_HOME = os.getenv('HOME') 
IDEA_EXEC = f"{USER_HOME}/IntelliJ/latest/bin/idea"

CONFIG_DIR = os.path.expanduser("~/.config/JetBrains")
recent_projects_file = None

class Project:
    def __init__(self, name, path):
        self.name = name
        self.path = path

    def select_label(self):
        return f'   {self.name}\t({self.path})'

    def select_option(self):
        return f'{self.select_label()}\0icon\x1f/home/bpayne/IntelliJ/latest/bin/idea.png'

for root, _, files in os.walk(CONFIG_DIR):
    for file in files:
        if file == "recentProjects.xml":
            recent_projects_file = os.path.join(root, file)

if not recent_projects_file:
    print("No recent projects found")
    exit(1)

try:
    tree = ET.parse(recent_projects_file)
    root = tree.getroot()
    projects: List[Project] = []

    for entry in root.findall(".//component[@name='RecentProjectsManager']/option[@name='additionalInfo']/map/entry"):
        project_path = entry.attrib.get("key")
        project_path = project_path.replace("$USER_HOME$", USER_HOME)
        meta_info = entry.find(".//value/RecentProjectMetaInfo")
        project_name = meta_info.attrib.get("frameTitle", 'Unknown')
        if project_path.endswith('light-edit'):
            continue
        if not os.path.isdir(project_path):
            continue

        if project_path and project_name:
            projects.append(Project(project_name, project_path))

except Exception as e:
    print(f"Error parsing projects: {e}")
    exit(1)

if len(projects) == 0:
    print("No recent projects found")
    exit(1)

if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1:
        selected_display = sys.argv[1]
        selected_project = None
        for project in projects:
            if selected_display == project.select_label():
                selected_project = project.path
                break

        if selected_project:
            subprocess.Popen([IDEA_EXEC, selected_project], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    else:
        print("\n".join(map(lambda p: p.select_option(), projects)))
