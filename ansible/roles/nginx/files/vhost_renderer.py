#!/usr/bin/env python2.7
import jinja2
import sys
from docopt import docopt

__doc__="""
Usage:
    vhost_renderer.py [--input_file=<input_file>] [--output_file=<output_file>] [--template_file=<template_file>]
"""

templateLoader = jinja2.FileSystemLoader(searchpath="/")
templateEnv = jinja2.Environment(loader=templateLoader)

def main(argv=None):
    args = docopt(__doc__, argv or sys.argv[1:])
    templateFile = args.get('--template_file')
    inputFile = args.get('--input_file')
    outputFile = args.get('--output_file')

    inputData = _get_input_data(inputFile)
    outputData = _generate_vhost_data(templateFile, inputData)
    _generate_vhost_file(outputFile, outputData)

def _get_input_data(inputFile):
    with open(inputFile, 'r') as f:
        firstLine = f.readline().strip()
    return { "upstream_server" : firstLine }

def _generate_vhost_data(templateFile, inputData):
    return templateEnv.get_template(templateFile).render(inputData)

def _generate_vhost_file(outputFile, outputData):
    with open(outputFile, "wb") as fh:
        fh.write(outputData)

if __name__ == '__main__':
    main()
