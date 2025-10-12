#!/usr/bin/env -S uv run --script

import os
import subprocess
import xml.etree.ElementTree as ET
from typing import List, Set

USER_HOME = os.getenv('HOME') 
IDEA_EXEC = f"{USER_HOME}/IntelliJ/latest/bin/idea"
CLION_EXEC = f"{USER_HOME}/CLion/latest/bin/clion"

CONFIG_DIR = os.path.expanduser("~/.config/JetBrains")
recent_projects_files = []

class Project:
    def __init__(self, name, path, jetbrains_exec):
        self.name = name
        self.path = path
        self.jetbrains_exec = jetbrains_exec

    def select_label(self):
        return f'   {self.name}\t({self.path})'

    def select_option(self):
        if self.jetbrains_exec == IDEA_EXEC:
            return f'{self.select_label()}\0icon\x1f/home/bpayne/IntelliJ/latest/bin/idea.png'
        elif self.jetbrains_exec == CLION_EXEC:
            return f'{self.select_label()}\0icon\x1f/home/bpayne/CLion/latest/bin/clion.png'
        else:
            return f'{self.select_label()}'

    def __hash__(self):
        return hash(self.path)

    def __eq__(self, other):
        return  self.path == other.path

for root, _, files in os.walk(CONFIG_DIR):
    for file in files:
        if file == "recentProjects.xml":
            recent_projects_files.append(os.path.join(root, file))

if not recent_projects_files:
    print("No recent projects found")
    exit(1)

projects: Set[Project] = set()
for recent_projects_file in recent_projects_files:
    jetbrains_exec = IDEA_EXEC if "Idea" in recent_projects_file else CLION_EXEC
    try:
        tree = ET.parse(recent_projects_file)
        root = tree.getroot()

        for entry in root.findall(".//component[@name='RecentProjectsManager']/option[@name='additionalInfo']/map/entry"):
            project_path = entry.attrib.get("key")
            project_path = project_path.replace("$USER_HOME$", USER_HOME)
            meta_info = entry.find(".//value/RecentProjectMetaInfo")
            if project_path.endswith('light-edit'):
                continue
            if not os.path.isdir(project_path):
                continue

            project_dir_name = os.path.split(project_path)[-1]
            project_name = meta_info.attrib.get("frameTitle", project_dir_name)

            if project_path and project_name:
                projects.add(
                    Project(
                        project_name,
                        project_path,
                        jetbrains_exec
                    )
                )

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
                selected_project = project
                break

        if selected_project:
            subprocess.Popen(
                [
                    selected_project.jetbrains_exec,
                    selected_project.path
                ],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
    else:
        print("\n".join(map(lambda p: p.select_option(), projects)))
