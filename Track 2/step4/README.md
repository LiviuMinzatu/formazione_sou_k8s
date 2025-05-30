# Setup ambiente Ubuntu Jenkins + Kubernetes

## Vagrant

Macchina virtuale basata su Ubuntu, configurata con:

- **Port forwarding** sulla porta `8080`
- **IP privato** assegnato: `192.168.56.11`

Il **task principale** consiste nell'avvio del playbook `main.yml`.


## Azioni principali del playbook main.yml

- Docker (per containerizzazione)
- Helm (package manager per Kubernetes)
- Jenkins (server CI/CD)
- Kind (Kubernetes IN Docker)
- kubectl (CLI per Kubernetes)
- Configurazione di Jenkins per interagire con Kubernetes (Kind)

---

## Componenti installati

### Docker

Installa e configura Docker, il motore per i container.

Cosa fa:
- Aggiunge il repository ufficiale di Docker
- Installa `docker-ce`, `docker-ce-cli`, `containerd.io`
- Abilita e avvia il servizio Docker

### Helm

Installa Helm, un gestore di pacchetti per Kubernetes.

Cosa fa:
- Aggiunge il repository e la chiave GPG di Helm
- Installa Helm
- Verifica l'installazione (`helm version`)

### Jenkins

Installa e configura Jenkins, uno strumento CI/CD.

Cosa fa:
- Installa Java (necessario per Jenkins)
- Aggiunge repository e chiave GPG
- Installa Jenkins
- Avvia e abilita Jenkins
- Attende che Jenkins sia attivo sulla porta 8080
- Stampa la password iniziale per la configurazione via web

### Kind (Kubernetes IN Docker)

Installa Kind per creare un cluster Kubernetes locale.

Cosa fa:
- Verifica che Docker sia installato
- Scarica e installa il binario di Kind
- Verifica che `kind` funzioni correttamente

### kubectl

Installa kubectl, la CLI ufficiale di Kubernetes.

Cosa fa:
- Recupera l’ultima versione stabile da Kubernetes API
- Scarica e installa `kubectl`
- Verifica l’installazione (`kubectl version --client`)

---

## Configurazione Jenkins per Kubernetes (Kind)

Configura Jenkins per poter interagire con il cluster Kind:

Cosa fa:
1. Aggiunge `vagrant` e `jenkins` al gruppo `docker`
2. Riavvia Jenkins
3. Verifica se esiste un cluster chiamato `jenkins-cluster`
4. Se non esiste, lo crea
5. Estrae il kubeconfig da Kind
6. Imposta i permessi corretti su kubeconfig
7. Copia il kubeconfig nella home di Jenkins (`/var/lib/jenkins/.kube/config`)
8. Verifica che Jenkins possa usare `kubectl` per accedere al cluster

---

## Risultato finale

Alla fine dell'esecuzione del playbook, si avrà:

- Un ambiente CI/CD completo funzionante in locale
- Jenkins collegato a un cluster Kubernetes
- Tutti i tool principali installati e configurati (Docker, kubectl, Helm, Kind)
- Pronto per sviluppare pipeline CI/CD su Kubernetes

---

## Requisiti

- Ubuntu 22.04
- Utente con privilegi sudo
- Ansible installato sul sistema di controllo, in questo caso MacOS

---

## Cartella pipelineUtili

### controlloFunzionamento.txt

Questo file contiene una pipeline pronta all'uso che verifica il corretto funzionamento di `kubectl` e `helm`.

### avvioConHelm.txt

Questo file contiene una pipeline che esegue specifiche azioni previste dallo step di avvio con `helm`.
