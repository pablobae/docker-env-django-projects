FROM python:3.8.3-alpine
MAINTAINER Pablo César Baenas Castelló

ENV PYTHONUNBUFFERED 1

# Dependencies
COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

# Workdir
RUN mkdir /src
WORKDIR /src
COPY ./src /src

# Create user to be used for running our applications only (and not root)
RUN adduser -D user
USER user
