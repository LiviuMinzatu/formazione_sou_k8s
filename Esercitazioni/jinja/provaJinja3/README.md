# Jinja2 Dockerfile Generator

This project uses a Jinja2 template to generate a custom Dockerfile.

## Folder Contents

Dockerfile.j2        Jinja2 template for the Dockerfile  
variables.yaml       File with the variables to be used in the template  
default.conf         Configuration file for Nginx  
generate.sh          Script to generate the Dockerfile using jinja2-cli  
Dockerfile           The generated Dockerfile (after running the script)

## Prerequisites

Make sure you have the following installed:

```bash
pip install jinja2-cli pyyaml
```

## How to generate the Dockerfile

Run the included script:

```bash
./generate.sh
```

Or manually:

```bash
jinja2 Dockerfile.j2 variables.yaml -o Dockerfile
```

## How to build the Docker image

After generating the Dockerfile:

```bash
docker build -t my-custom-nginx .
```

## How to run the container

```bash
docker run -d -p 8080:80 my-custom-nginx
```
