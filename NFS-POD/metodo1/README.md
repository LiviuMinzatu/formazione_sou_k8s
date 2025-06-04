# Configurazione NFS e test con Pod Kubernetes

Questa guida descrive come configurare un server NFS su una VM e montare la share NFS direttamente all'interno di un Pod Kubernetes, verificando che la comunicazione e la scrittura funzionino correttamente.

---

## 1. Configura il server NFS 

### Installa il server NFS

``` bash
sudo apt update
sudo apt install -y nfs-kernel-server
```
### Crea la directory da esportare
```bash
sudo mkdir -p /srv/nfs/kshare
sudo chown nobody:nogroup /srv/nfs/kshare
sudo chmod 777 /srv/nfs/kshare   # (solo per testing, attenzione in produzione)
```

### Aggiungi la directory a /etc/exports
Modifica il file:
```bash
sudo nano /etc/exports
```
Aggiungi questa riga in fondo:
```bash
/srv/nfs/kshare  *(rw,sync,no_subtree_check,no_root_squash)
```


### Applica la configurazione
```bash
sudo exportfs -rav
sudo systemctl restart nfs-kernel-server
```

---

## 2. Verifica l'esportazione dal tuo host o da un'altra VM

```bash
showmount -e 192.168.56.10
```
Output atteso:
```bash
Export list for 192.168.56.10:
/srv/nfs/kshare *
```
---

## 3. Avvia il Pod Kubernetes
```bash
kubectl apply -f podSemplice.yaml
```
---

## 4. Entra nel Pod e testa la scrittura
```bash
kubectl exec -it nfs-pod -- sh
```
Dentro il Pod:
```bash
cd /mnt/nfs
echo "Scrittura OK dal Pod" > test.txt
cat test.txt
```
---

## 5. Verifica sulla macchina server NFS
```bash
cat /srv/nfs/kshare/test.txt
```
Output atteso:
```bash
Scrittura OK dal Pod
```
---

## Fine
