#!/bin/bash                                             
# Check if jinja2 CLI is installed
if ! command -v jinja2 &> /dev/null                       # Check if 'jinja2' command is available
then
    echo "jinja2-cli non trovato. Installa con: pip3 install jinja2-cli[yaml]"  # Show message if not installed
    exit 1                                                # Exit script with error code
fi

# Render the Dockerfile from the Jinja2 template using variables.yaml
jinja2 Dockerfile.j2 variables.yaml --format=yaml > Dockerfile  # Generate Dockerfile using jinja2 and YAML input
echo "Dockerfile generato!"                              # Success message
