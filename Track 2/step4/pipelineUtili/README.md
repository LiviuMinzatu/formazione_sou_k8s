# Helm and Kubectl Verification Pipeline

This Jenkins pipeline performs a full check on `helm` and `kubectl`, verifying that they are installed, functional, and able to connect to the Kubernetes cluster.

## Pipeline Stages

### 1. Check for helm and kubectl
Ensures that `helm` and `kubectl` commands are available in the system. If not, the pipeline stops with an error.

### 2. Functionality Check
- Prints the versions of `helm` and `kubectl`
- Checks if `kubectl` is connected to the cluster (`kubectl cluster-info`)
- Checks if `helm` can connect to the cluster (`helm list`)
- Creates the `formazione-sou` namespace if it doesn't exist
- Lists all namespaces in the cluster

## Pipeline Outcome

- If any step fails, an error message is displayed and the pipeline stops.
- If successful, it confirms that `helm` and `kubectl` are installed and working properly.


# Helm Pipeline: Temporary Deploy on Kubernetes

This Jenkins pipeline clones a Git repository containing a Helm chart, installs it on Kubernetes, waits one minute, and then uninstalls it. Useful for testing or quick validation.

## Pipeline Stages

### 1. Clone the repository
Clones the Git repository specified by the `REPO_URL` variable, branch `main`.

### 2. Create namespace (if not exists)
Checks whether the specified namespace (`formazione-sou`) exists. If not, it creates it.

### 3. Install Helm chart
Installs the Helm chart located at `Track 2/flask-app`, using:
- Release name: `formazione-release`
- Namespace: `formazione-sou`

### 4. Wait 1 minute
Waits 1 minute before proceeding to uninstallation. This allows time for the pod to start and for deployment verification.

### 5. Uninstall Helm release
Uninstalls the just-created Helm release, freeing up cluster resources.

## Environment Variables

- `REPO_URL`: Git repository URL
- `CHART_PATH`: Path to the Helm chart inside the repo
- `RELEASE_NAME`: Name of the Helm release
- `NAMESPACE`: Kubernetes namespace to use

## Pipeline Outcome

At the end of execution, the Helm release is removed and the message **"Pipeline completed."** is displayed.
