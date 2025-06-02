
# Jenkins + Vagrant + Ansible

Questo progetto nasce per sperimentare l’utilizzo delle **REST API di Jenkins** in un ambiente controllato e isolato.

L’intero ambiente è stato costruito utilizzando **Vagrant** e **Ansible**, con l’obiettivo di avere una configurazione **riproducibile**, **pronta all’uso** e facilmente estendibile.

---

## Struttura del progetto

- `Vagrantfile`: definisce due VM (jenkins e agent)
- `inventory.ini`: definisce gli host per Ansible
- `playbook.yml`: eseguito automaticamente da Vagrant per il setup base
- `postPerJenkins.yml`: crea l'agente Jenkins via API (da eseguire manualmente)
- `postAgent.yml`: scarica e avvia l'agente JNLP (manuale)
- `Guida.txt`: appunti o guida locale (ne avevo davvero bisogno, sono fondamentali)
- `README.md`: questo file

---

## Procedura di utilizzo

### 1. Avvia l’ambiente

```bash
vagrant up
```

### 2. Accedi alla VM Jenkins

```bash
vagrant ssh jenkins
```

### 3. Recupera la password iniziale

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 4. Configura Jenkins

- Accedi alla UI: [http://192.168.56.10:8080](http://192.168.56.10:8080)
- Completa la configurazione guidata
- Crea l’utente `admin`
- Genera un **API Token**
saluto chi sta leggendo!!

### 5. Verifica la porta 50000

Assicurati che sia esposta per la connessione dell’agente JNLP.
è fondamentale, ho perso molto tempo per capirlo

### 6. Esegui i playbook manuali

```bash
ansible-playbook -i inventory.ini postPerJenkins.yml -e jenkins_api_token=<TOKEN>
ansible-playbook -i inventory.ini postAgent.yml -e jenkins_api_token=<TOKEN>
```

Sostituisci `<TOKEN>` con il token API generato.

---

## Obiettivo

- Automatizzare la **creazione di nodi Jenkins** tramite REST API
- Gestire da codice la configurazione di Jenkins e dei suoi agenti
- Fornire un ambiente **riproducibile** e adatto a test locali

---

## Requisiti

- Vagrant
- VirtualBox
- Ansible
- Linux
