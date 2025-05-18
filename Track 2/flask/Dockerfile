# Usa un'immagine Python come base
FROM python:3.10-slim

# Imposta la directory di lavoro
WORKDIR /app

# Copia i file
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

# Espone la porta
EXPOSE 5000

# Comando per avviare Flask
CMD ["python", "app.py"]
