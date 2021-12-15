# syntax=docker/dockerfile:1

FROM docker.io/mongo:latest

ENV MONGO_INITDB_ROOT_USERNAME root
ENV MONGO_INITDB_ROOT_PASSWORD 123
ENV MONGO_INITDB_DATABASE admin

COPY mongodb-init.js /docker-entrypoint-initdb.d/

