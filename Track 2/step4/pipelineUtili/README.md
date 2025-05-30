# Pipeline di Verifica Helm e Kubectl

Questa pipeline Jenkins esegue un controllo completo su `helm` e `kubectl`, verificando che siano installati e funzionanti, e che possano connettersi correttamente al cluster Kubernetes.

## Fasi della Pipeline

### 1. Controllo presenza helm e kubectl
Verifica che i comandi `helm` e `kubectl` siano disponibili nel sistema. In caso contrario, la pipeline viene interrotta con un errore.

### 2. Verifica funzionamento
- Stampa le versioni di `helm` e `kubectl`
- Controlla che `kubectl` sia connesso al cluster (`kubectl cluster-info`)
- Controlla che `helm` riesca a connettersi (`helm list`)
- Crea il namespace `formazione-sou` se non esiste
- Elenca tutti i namespace del cluster

## Esito della Pipeline

- In caso di errore in uno qualsiasi degli step, viene mostrato un messaggio di errore e la pipeline termina.
- In caso di successo, viene confermato che `helm` e `kubectl` sono installati e operativi.


# Pipeline Helm: Deploy Temporaneo su Kubernetes

Questa pipeline Jenkins clona un repository Git contenente una Helm chart, la installa su Kubernetes, attende un minuto e poi la disinstalla. È utile per test o validazioni rapide.

## Fasi della Pipeline

### 1. Clona il repository
Clona il repository Git specificato nella variabile `REPO_URL`, branch `main`.

### 2. Crea namespace (se non esiste)
Controlla se il namespace specificato (`formazione-sou`) esiste. In caso contrario, lo crea.

### 3. Installa Helm chart
Installa la Helm chart contenuta nel percorso `Track 2/flask-app`, usando:
- Nome release: `formazione-release`
- Namespace: `formazione-sou`

### 4. Attendi 1 minuto
Attende 1 minuto prima di procedere alla disinstallazione. Serve per dare tempo al pod di avviarsi e verificare il deploy.

### 5. Disinstalla Helm release
Disinstalla la release Helm appena creata, liberando risorse nel cluster.

## Variabili di ambiente

- `REPO_URL`: URL del repository Git
- `CHART_PATH`: Percorso della chart Helm all'interno del repo
- `RELEASE_NAME`: Nome della release Helm
- `NAMESPACE`: Namespace Kubernetes dove operare


## Esito della Pipeline

Al termine dell’esecuzione, la Helm release viene rimossa e viene stampato il messaggio **"Pipeline terminata."**
