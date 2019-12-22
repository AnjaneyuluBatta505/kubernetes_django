FROM python:3.6-slim
MAINTAINER Anjaneyulu Batta <anjaneyulu.batta505@gmail.com>
RUN apt-get update
ENV PROJECT_ROOT /app
WORKDIR $PROJECT_ROOT

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .
CMD python manage.py runserver 0.0.0.0:8000
