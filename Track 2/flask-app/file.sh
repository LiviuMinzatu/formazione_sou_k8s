#!/bin/bash

NAMESPACE="formazione-sou"
DEPLOYMENT_NAME="formazione-release-flask-app"

# Ottieni JSON del deployment
DEPLOYMENT_JSON=$(kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o json)

if [ -z "$DEPLOYMENT_JSON" ]; then
  echo "Errore: Deployment non trovato."
  exit 1
fi

# Funzione per controllare un campo usando jq su ogni container
check_field() {
  local field="$1"
  local label="$2"
  local found=0

  # Per ogni container, controlla se il campo è presente
  for container in $(echo "$DEPLOYMENT_JSON" | jq -r '.spec.template.spec.containers[].name'); do
    match=$(echo "$DEPLOYMENT_JSON" | jq ".spec.template.spec.containers[] | select(.name==\"$container\") | $field")
    if [ "$match" != "null" ]; then
      echo "PRESENTE: $label nel container '$container'"
      found=1
    fi
  done

  if [ $found -eq 0 ]; then
    echo "MANCANTE: $label"
    return 1
  fi
  return 0
}

# Controlli
ERRORS=0
check_field '.readinessProbe' "Readiness Probe" || ERRORS=$((ERRORS+1))
check_field '.livenessProbe' "Liveness Probe" || ERRORS=$((ERRORS+1))
check_field '.resources.limits' "Resources Limits" || ERRORS=$((ERRORS+1))
check_field '.resources.requests' "Resources Requests" || ERRORS=$((ERRORS+1))

# Risultato
if [ "$ERRORS" -eq 0 ]; then
  echo "Tutti i controlli sono stati superati."
  exit 0
else
  echo "Sono stati trovati $ERRORS problemi con le best practices del Deployment."
  exit 1
fi
