FROM python:3.9 AS build

WORKDIR /src


RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
RUN git clone -b master https://github.com/docker/awesome-compose.git


WORKDIR /src/awesome-compose/nginx-flask-mysql/backend
RUN python -m pip install --upgrade pip && pip install Werkzeug==2.0.3 && pip install -r requirements.txt

ENV FLASK_APP=hello.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000

CMD ["flask","run"]