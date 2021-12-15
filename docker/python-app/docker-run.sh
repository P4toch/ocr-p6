#!/usr/bin/bash

clear
echo "________________________________________________________________"
echo ">> Stopping and deleting docker container python-app"
docker container stop python-app
docker container rm python-app
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Creating docker network my-network"
docker network rm my-network
docker network create --subnet=172.18.0.0/16 my-network
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Running docker container python-app:0.0.1"
docker run -d -p 5000:5000 --net my-network -h python-app --name python-app --ip 172.18.0.10 python-app:0.0.1
sleep 3

echo ""
echo "________________________________________________________________"
echo ">> Listing docker containers"
docker container ps

echo ""
