# Dockerfile corregido

FROM python:3.9-slim

WORKDIR /home/myapp

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# Se añade --upgrade setuptools para actualizar jaraco.context y wheel internos
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5050
CMD ["python", "sample_app.py"]