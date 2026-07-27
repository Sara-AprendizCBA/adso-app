FROM python:3.9-slim
WORKDIR /home/myapp
COPY ./static ./static
COPY ./templates ./templates
COPY sample_app.py .
RUN pip install flask mysql-connector-python
EXPOSE 5050
CMD ["python", "sample_app.py"]
