#!/usr/bin/bash

clear
echo "________________________________________________________________"
echo ">> Removing docker image python-app:0.0.1"
docker image rm --force python-app:0.0.1
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Building docker image from Dockerfile"
docker build --tag python-app:0.0.1 .
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Listing docker images"
docker image ls

