#!/usr/bin/python3

import sys

color_map = {
    'nagatha': 'yellow',
    'stm': 'blue',
    'work': 'purple',
}

def main():
    for line in sys.stdin:
        host = line.strip()
        color = color_map.get(host, 'blue')
        print(color)

if __name__ == '__main__':
    main()
