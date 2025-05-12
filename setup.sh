#!/bin/bash

# Directory dove creare l'app (modifica se vuoi cambiarla)
APP_DIR="$HOME/Desktop/Git/formazione_sou_k8s/flask_app"

# Crea la directory
mkdir -p "$APP_DIR"

# Crea app.py
cat > "$APP_DIR/app.py" <<EOF
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "hello world"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

# Crea requirements.txt
cat > "$APP_DIR/requirements.txt" <<EOF
flask==2.2.5
EOF

# Crea Dockerfile
cat > "$APP_DIR/Dockerfile" <<EOF
# syntax=docker/dockerfile:1
FROM python:3.10-slim

WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .
CMD ["python", "app.py"]
EOF

echo "✅ App Flask generata in: $APP_DIR"

