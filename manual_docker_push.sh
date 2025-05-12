#!/bin/bash

# Configura il tuo Docker Hub username
DOCKER_HUB_USER="freddo18"
IMAGE_NAME="$DOCKER_HUB_USER/flask-hello-world"

# Cartella app
APP_DIR="flask_app"

# Ricava dati Git
BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT=$(git rev-parse --short HEAD)
TAG=$(git describe --tags --exact-match 2>/dev/null)

# Determina il tag da usare
if [ -n "$TAG" ]; then
  IMAGE_TAG="$TAG"
elif [ "$BRANCH" == "master" ] || [ "$BRANCH" == "main" ]; then
  IMAGE_TAG="latest"
elif [ "$BRANCH" == "develop" ]; then
  IMAGE_TAG="develop-$COMMIT"
else
  echo "❌ Branch/tag non gestito: $BRANCH"
  exit 1
fi

# Mostra info
echo "📦 Building image: $IMAGE_NAME:$IMAGE_TAG"

# Build dell'immagine
docker build -t "$IMAGE_NAME:$IMAGE_TAG" "$APP_DIR"

# Login Docker Hub (usa la password o un Personal Access Token)
echo "🔐 Inserisci password o token Docker Hub per $DOCKER_HUB_USER"
docker login -u "$DOCKER_HUB_USER"

# Push immagine
docker push "$IMAGE_NAME:$IMAGE_TAG"

# Logout
docker logout

echo "✅ Push completato: $IMAGE_NAME:$IMAGE_TAG"
