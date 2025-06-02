#!/bin/bash

# Imposta il namespace Kubernetes dove si trova il Deployment
NAMESPACE="formazione-sou"

# Imposta il nome del Deployment da controllare
DEPLOYMENT_NAME="formazione-release-flask-app"

# Recupera il Deployment in formato JSON
# Questo consente di analizzare facilmente i dati con jq
DEPLOYMENT_JSON=$(kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o json)

# Se il Deployment non esiste o il comando fallisce, esci con errore
if [ -z "$DEPLOYMENT_JSON" ]; then
  echo "Errore Deployment non trovato"
  exit 1
fi

# Definisce una funzione per controllare se un campo specifico è presente in ogni container
check_field() {
  local field="$1"    # Nome del campo da controllare nel container
  local label="$2"    # Nome descrittivo del campo da stampare a schermo
  local found=0       # Variabile per tenere traccia se almeno un container ha il campo

  # Itera su tutti i container presenti nel Deployment
  for container in $(echo "$DEPLOYMENT_JSON" | jq -r '.spec.template.spec.containers[].name'); do
    # Estrae il campo specificato per il container corrente
    match=$(echo "$DEPLOYMENT_JSON" | jq ".spec.template.spec.containers[] | select(.name==\"$container\") | $field")

    # Se il campo esiste ed è diverso da null, lo segnala come presente
    if [ "$match" != "null" ]; then
      echo "PRESENTE $label nel container $container"
      found=1
    fi
  done

  # Se nessun container contiene il campo, lo segnala come mancante
  if [ $found -eq 0 ]; then
    echo "MANCANTE $label"
    return 1  # La funzione restituisce errore
  fi
  return 0  # La funzione restituisce successo
}

# Inizializza il contatore degli errori a zero
ERRORS=0

# Controlla se i container hanno il readinessProbe configurato
check_field '.readinessProbe' "Readiness Probe" || ERRORS=$((ERRORS+1))

# Controlla se i container hanno il livenessProbe configurato
check_field '.livenessProbe' "Liveness Probe" || ERRORS=$((ERRORS+1))

# Controlla se i container hanno definito dei limiti di risorse
check_field '.resources.limits' "Resources Limits" || ERRORS=$((ERRORS+1))

# Controlla se i container hanno definito delle richieste di risorse
check_field '.resources.requests' "Resources Requests" || ERRORS=$((ERRORS+1))

# Se non sono stati rilevati errori, tutti i controlli sono stati superati
if [ "$ERRORS" -eq 0 ]; then
  echo "Tutti i controlli sono stati superati"
  exit 0
else
  # Se ci sono errori, stampa quanti sono e termina con codice di errore
  echo "Sono stati trovati $ERRORS problemi con le best practices del Deployment"
  exit 1
fi

# Commenti utili se jq non è già installato
# Per installare jq su Ubuntu
# sudo apt update
# sudo apt install jq -y