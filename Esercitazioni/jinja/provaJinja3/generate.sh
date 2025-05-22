#!/bin/bash

if ! command -v jinja2 &> /dev/null
then
    echo "jinja2-cli non trovato. Installa con: pip3 install jinja2-cli[yaml]"
    exit 1
fi

jinja2 Dockerfile.j2 variables.yaml --format=yaml > Dockerfile
echo " Dockerfile generato!"
