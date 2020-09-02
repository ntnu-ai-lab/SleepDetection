"""
Utility script for fixing the absolute paths located in the notebooks folder

It is needed because the provided notebooks contained a bunch of
absolute windows paths.

This script parses each notebook and replaced "[D|C]:/path" -> "../data/labelled"
"""
import argparse
import json

parser = argparse.ArgumentParser("Replaces hardcoded paths in the provided notebooks")
parser.add_argument(
    'files',
    nargs='+',
    help='Files to replace paths in'
)

for file in parser.parse_args().files:
    print('Fixing file:', file)
    with open(file, 'r') as f:
        notebook = json.load(f)

    for cell in notebook['cells']:
        cell['source'] = [
            (line
                .replace('D:/path', '../data/labelled')
                .replace('C:/path', '../data/labelled')
            ) for line in cell['source']
        ]

    with open(file, 'w') as f:
        json.dump(notebook, f, indent=4)
