# Progetto Kubernetes + NFS (Metodo 2)

Questo progetto mostra come configurare una share NFS su una VM e montarla in un Pod Kubernetes tramite PersistentVolume (PV) e PersistentVolumeClaim (PVC).

---

## 1. Configura il server NFS 

Da dentro la cartella `metodo2/`:

```
vagrant up
```

### Installa il server NFS
```bash
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

## 2. Verifica che la share NFS sia attiva

Dal tuo host o da un’altra VM:

```
showmount -e 192.168.56.10
```

Output atteso:

```
Export list for 192.168.56.10:
/srv/nfs/kshare *
```

---

## 3. Crea le risorse Kubernetes

Applica i seguenti file nell'ordine:

```
kubectl apply -f nfs-pv.yaml
kubectl apply -f nfs-pvc.yaml
kubectl apply -f nfs-pod.yaml
```

---

## 4. Verifica che il Pod sia attivo

```
kubectl get pods
```

Dovresti vedere `nfs-pod` in stato `Running`.

---

## 5. Testa il montaggio NFS

Accedi al Pod:

```
kubectl exec -it nfs-pod -- sh
```

All'interno del Pod:

```
cd /mnt/nfs
echo "Test da Kubernetes" > test.txt
cat test.txt
```

Esci dal Pod:

```
exit
```

---

## 6. Verifica lato server (nella VM Vagrant)

Connettiti alla VM:

```
vagrant ssh
```

E controlla il contenuto della cartella esportata:

```
cat /srv/nfs/kshare/test.txt
```

Output atteso:

```
Test da Kubernetes
```

---

## Fine

Se vedi correttamente il file scritto sia dal Pod che dal server NFS, il montaggio funziona.
