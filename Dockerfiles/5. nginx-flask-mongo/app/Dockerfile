FROM python:3.11-slim
LABEL Author="Akshat"

WORKDIR /src
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
RUN git clone -b master https://github.com/docker/awesome-compose.git

WORKDIR /src/awesome-compose/nginx-flask-mongo/flask
RUN python -m pip install --upgrade pip && pip install -r requirements.txt

CMD ["python","server.py"]