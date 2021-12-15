#!/usr/bin/bash

clear
echo "________________________________________________________________"
echo ">> Removing docker image my-mongodb:0.0.1"
docker image rm --force my-mongodb:0.0.1
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Building docker image from Dockerfile"
docker build --tag my-mongodb:0.0.1 .
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Listing docker images"
docker image ls

