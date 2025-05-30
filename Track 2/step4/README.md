# Ubuntu Environment Setup: Jenkins + Kubernetes

## Vagrant

A virtual machine based on Ubuntu, configured with:

- **Port forwarding** on port `8080`  
- **Private IP** assigned: `192.168.56.11`

The **main task** is to run the `main.yml` playbook.

## Main Actions of the `main.yml` Playbook

- Docker (for containerization)  
- Helm (package manager for Kubernetes)  
- Jenkins (CI/CD server)  
- Kind (Kubernetes IN Docker)  
- kubectl (Kubernetes CLI)  
- Jenkins configuration to interact with Kubernetes (Kind)

---

## Installed Components

### Docker

Installs and configures Docker, the container engine.

What it does:
- Adds the official Docker repository  
- Installs `docker-ce`, `docker-ce-cli`, `containerd.io`  
- Enables and starts the Docker service

### Helm

Installs Helm, a package manager for Kubernetes.

What it does:
- Adds the Helm repository and GPG key  
- Installs Helm  
- Verifies the installation (`helm version`)

### Jenkins

Installs and configures Jenkins, a CI/CD tool.

What it does:
- Installs Java (required by Jenkins)  
- Adds the Jenkins repository and GPG key  
- Installs Jenkins  
- Starts and enables the Jenkins service  
- Waits for Jenkins to become available on port 8080  
- Prints the initial password for web-based setup

### Kind (Kubernetes IN Docker)

Installs Kind to create a local Kubernetes cluster.

What it does:
- Checks if Docker is installed  
- Downloads and installs the Kind binary  
- Verifies that `kind` is working properly

### kubectl

Installs `kubectl`, the official Kubernetes CLI.

What it does:
- Fetches the latest stable version from the Kubernetes API  
- Downloads and installs `kubectl`  
- Verifies the installation (`kubectl version --client`)

---

## Jenkins Configuration for Kubernetes (Kind)

Configures Jenkins to interact with the Kind cluster:

What it does:
1. Adds `vagrant` and `jenkins` users to the `docker` group  
2. Restarts Jenkins  
3. Checks if a cluster named `jenkins-cluster` exists  
4. If not, creates it  
5. Extracts the kubeconfig from Kind  
6. Sets correct permissions on the kubeconfig  
7. Copies the kubeconfig to Jenkins' home directory (`/var/lib/jenkins/.kube/config`)  
8. Verifies that Jenkins can use `kubectl` to access the cluster

---

## Final Result

After the playbook execution, you will have:

- A fully functional local CI/CD environment  
- Jenkins connected to a Kubernetes cluster  
- All essential tools installed and configured (Docker, kubectl, Helm, Kind)  
- Ready to develop CI/CD pipelines on Kubernetes

---

## Requirements

- Ubuntu 22.04  
- User with sudo privileges  
- Ansible installed on the control system (in this case, macOS)

---

## `pipelineUtili` Folder

### `controlloFunzionamento.txt`

This file contains a ready-to-use pipeline that checks the proper functioning of `kubectl` and `helm`.

### `avvioConHelm.txt`

This file contains a pipeline that performs specific actions related to the Helm startup step.
