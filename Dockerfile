FROM python:3.9-slim

WORKDIR /home/myapp

# Actualizar el sistema base para parchear vulnerabilidades de Debian
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5050
CMD ["python", "sample_app.py"]