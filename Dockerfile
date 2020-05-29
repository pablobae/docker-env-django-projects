FROM python:3.8.3-alpine
MAINTAINER Pablo César Baenas Castelló

ENV PYTHONUNBUFFERED 1

# Dependencies
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# Workdir
RUN mkdir /src
WORKDIR /src
COPY ./src /src

# Create user to be used for running our applications only (and not root)
RUN adduser -D user
USER user
