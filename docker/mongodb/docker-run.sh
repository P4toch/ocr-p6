#!/usr/bin/bash

clear
echo "________________________________________________________________"
echo ">> Stopping and deleting docker container my-mongodb"
docker container stop my-mongodb
docker container rm my-mongodb
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Creating docker network my-network"
docker network rm my-network
docker network create --subnet=172.18.0.0/16 my-network
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Running docker container mongo:latest"
docker run -d -p 27017:27017 --net my-network --ip 172.18.0.20 -h my-mongodb --name my-mongodb my-mongodb:0.0.1
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Listing docker containers"
docker container ps

echo ""

