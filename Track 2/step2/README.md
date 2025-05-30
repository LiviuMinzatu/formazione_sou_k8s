# Jenkins CI/CD with Docker on Vagrant (Rocky Linux 9)

This project aims to automate the creation of a CI/CD environment using Jenkins, Docker (or Podman), Vagrant, and Ansible. The entire environment is created on a Rocky Linux 9 VM run via Vagrant, limited to x86_64 architectures (not compatible with Apple Silicon ARM).

## Project Goals

1. Create a Rocky Linux 9 VM using Vagrant
2. Install Docker or Podman using Ansible
3. Configure a static network for Docker/Podman using Ansible
4. Install Jenkins Master as a Docker/Podman container with a static IP
5. Install and connect a Jenkins Agent via container
6. Create a Jenkins pipeline to build and publish a Flask WebApp on DockerHub
7. Manage dynamic Docker tagging based on Git branches and tags

## Requirements

- Host system with Intel/AMD processor (no Apple Silicon)
- VirtualBox installed
- Vagrant installed
- Ansible installed on the host system
- GitHub account
- DockerHub account


## Component Details

### Vagrant

The `Vagrantfile` creates a VM with the following characteristics:

- Operating System: Rocky Linux 9
- Private IP: 192.168.56.25
- Provisioning via local Ansible (`ansible_local`)

### Ansible Playbook

The `main_playbook.yml` performs the following tasks:

- Installs Docker or Podman
- Creates a static Docker/Podman network (e.g., `jenkins_net`, subnet `172.30.0.0/16`)
- Runs the Jenkins Master container with a static IP (e.g., `172.30.0.10`)
- Runs a Jenkins Agent container connected to the master via JNLP

### Docker/Podman Network

A dedicated bridge network is created for Jenkins containers, necessary for assigning static IPs and direct communication between Master and Agent.

### Jenkins

Jenkins is installed as a container and configured to accept dynamic agents. Credentials and jobs can be configured via the graphical interface.

## Sample Application (Flask)

Inside the `flask` folder, there is a simple Python Flask application exposing an endpoint at `/` and returning the string "hello world".

### Example `app.py`

```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "hello world"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

### Example `Dockerfile`

```Dockerfile
FROM python:3.10-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

## Jenkins Pipeline: `Jenkinsfile`

The `flask-app-example-build` pipeline is defined declaratively and includes the following steps:

1. Clone the Git repository
2. Determine the Docker image tag:
   - If a Git tag is present, it is used as the image tag
   - If the branch is `main` (or `master`), the tag is `latest`
   - If the branch is `develop`, the tag is `develop-<commit SHA>`
3. Build the Docker image
4. Push the image to DockerHub
5. Clean up the local image

### Example logic for dynamic tagging

```groovy
def getDockerTag() {
    if (env.GIT_TAG_NAME) {
        return env.GIT_TAG_NAME
    } else if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master') {
        return 'latest'
    } else if (env.BRANCH_NAME == 'develop') {
        return "develop-${env.GIT_COMMIT[0..6]}"
    } else {
        return "custom-${env.GIT_COMMIT[0..6]}"
    }
}
```

If you’ve made it this far, you’re truly awesome! Randomly

## DockerHub Credentials Configuration

In Jenkins:

1. Go to `Manage Jenkins > Credentials`
2. Add credentials of type `Username/Password`
3. Save them with ID: `dockerhub`

The pipeline will use these credentials to authenticate with DockerHub during the push.

## Running the Environment

1. Clone the repository

```bash
git clone https://github.com/LiviuMinzatu/formazione_sou_k8s.git
cd formazione_sou_k8s
```

2. Start the VM with full provisioning

```bash
vagrant up
```

The VM will be accessible at `192.168.56.25`. Jenkins will be available on port `8080` (e.g., http://192.168.56.25:8080).

## Additional Considerations

- The Jenkins Agent container has access to the host Docker socket via a shared volume (`/var/run/docker.sock`), allowing image building and pushing
- The project can be extended to start a container with the Flask app at the end of the pipeline as an optional exercise

## Important Notice

Until the next patch is released, the VM does not have internet access immediately after running `vagrant up`.  
As a temporary workaround, you can manually restore connectivity by running the following command:

```bash
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
```
There are also a few other minor issues currently present, which will be addressed soon in future updates.


## Project currently under development. New improvements will be available soon.