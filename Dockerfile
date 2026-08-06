FROM python:3.9-slim

WORKDIR /home/myapp

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5050
CMD ["python", "sample_app.py"] 