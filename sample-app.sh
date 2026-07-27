#!/bin/bash

# Detener y eliminar contenedor anterior si existe
docker stop app-backend 2>/dev/null
docker rm app-backend 2>/dev/null
docker stop samplerunning 2>/dev/null
docker rm samplerunning 2>/dev/null

# Eliminar imagen anterior si existe
docker rmi sampleapp 2>/dev/null

# Crear carpeta temporal y copiar archivos necesarios
mkdir -p tempdir
mkdir -p tempdir/templates
mkdir -p tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Crear Dockerfile dentro de tempdir
cat > tempdir/Dockerfile << 'INNER_EOF'
FROM python:3.9-slim
WORKDIR /home/myapp
COPY ./static ./static
COPY ./templates ./templates
COPY sample_app.py .
RUN pip install flask mysql-connector-python
EXPOSE 5050
CMD ["python", "sample_app.py"]
INNER_EOF

# Construir la imagen
cd tempdir
docker build -t sampleapp .

# Ejecutar el contenedor en la red red-cba
docker run -t -d -p 5050:5050 --name app-backend --network red-cba sampleapp

# Volver al directorio anterior
cd ..

# Verificar
echo "========================================"
echo "Contenedor iniciado. Verificación:"
docker ps | grep -E "app-backend|servidor-bd"
echo "========================================"
echo "Abre en el navegador: http://localhost:5050"
echo "========================================"
