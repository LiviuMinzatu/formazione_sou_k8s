#!/bin/bash

# Percorso dove creare il Jenkinsfile
TARGET_DIR="$HOME/Desktop/Git/formazione_sou_k8s"
JENKINSFILE="$TARGET_DIR/Jenkinsfile"

# Crea Jenkinsfile
cat > "$JENKINSFILE" <<'EOF'
pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = 'TUO_USERNAME_DOCKER_HUB'
        IMAGE_NAME = "\${DOCKER_HUB_USER}/flask-hello-world"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Tag') {
            steps {
                script {
                    def branch = env.GIT_BRANCH.replaceFirst(/^origin\//, '')
                    def commit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def tag = sh(script: "git describe --tags --exact-match || true", returnStdout: true).trim()

                    if (tag) {
                        env.IMAGE_TAG = tag
                    } else if (branch == 'master') {
                        env.IMAGE_TAG = 'latest'
                    } else if (branch == 'develop') {
                        env.IMAGE_TAG = "develop-${commit}"
                    } else {
                        error "Branch/tag non gestito: ${branch}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('flask_app') {
                    script {
                        sh "docker build -t \${IMAGE_NAME}:\${IMAGE_TAG} ."
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                        sh "docker push \${IMAGE_NAME}:\${IMAGE_TAG}"
                        sh "docker logout"
                    }
                }
            }
        }
    }
}
EOF

echo "✅ Jenkinsfile creato in: $JENKINSFILE"

