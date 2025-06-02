# flask-app Helm Chart

Chart Helm per il deploy di una semplice applicazione Flask su Kubernetes.  
Include supporto per ingress, probes, risorse, HPA, service account, test post-deploy e configurazione flessibile tramite `values.yaml`.

## Requisiti

- Kubernetes 
- Helm 
- Ingress Controller (es. nginx) se `ingress.enabled` è attivo
- `kubectl` e accesso al cluster configurato
- `jq` per gli script

## Installazione

Clona la repo e lancia l’installazione:

```bash
helm install flask-app ./flask-app-chart --namespace formazione-sou --create-namespace
```

Per aggiornare una release esistente:

```bash
helm upgrade flask-app ./flask-app-chart --namespace formazione-sou
```

## Configurazione

Tutti i valori sono configurabili tramite il file `values.yaml`.

Esempio di configurazione base:

```yaml
replicaCount: 1

image:
  repository: freddo18/flask-app
  tag: latest
  pullPolicy: IfNotPresent

containerPort: 5000

resources:
  limits:
    memory: "128Mi"
    cpu: "250m"
  requests:
    memory: "64Mi"
    cpu: "100m"

readinessProbe:
  httpGet:
    path: /
    port: 5000
  initialDelaySeconds: 5
  periodSeconds: 10

livenessProbe:
  httpGet:
    path: /
    port: 5000
  initialDelaySeconds: 15
  periodSeconds: 20

service:
  type: ClusterIP
  port: 5000

serviceAccount:
  create: true
  automount: true

ingress:
  enabled: true
  className: nginx
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
  hosts:
    - host: formazionesou.local
      paths:
        - path: /
          pathType: Prefix
  tls: []

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 3
  targetCPUUtilizationPercentage: 80
```

## Test del Deployment

Questo chart include un test automatico eseguito da Helm al termine del deploy. Il test verifica la raggiungibilità del servizio:

```bash
helm test flask-app --namespace formazione-sou
```

Puoi anche eseguire uno script di validazione per controllare se il Deployment segue le best practices:

```bash
./script.sh
```

Questo script verifica:

- readinessProbe
- livenessProbe
- resources.limits
- resources.requests

## Accesso all'applicazione

### Se usi Ingress:

Accedi via browser all’indirizzo:

http://formazionesou.local/

è necessario aver configurato il DNS locale o modificato il file `/etc/hosts`:

127.0.0.1 formazionesou.local


## File principali

- `templates/deployment.yaml`: definisce il Deployment dei pod Flask
- `templates/service.yaml`: crea il Service per esporre l’app
- `templates/ingress.yaml`: configura l’accesso tramite Ingress
- `templates/hpa.yaml`: abilita autoscaling orizzontale
- `templates/serviceaccount.yaml`: crea un ServiceAccount dedicato
- `templates/tests/test-connection.yaml`: test automatico post-deploy
