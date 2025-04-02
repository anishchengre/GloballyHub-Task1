#!/bin/bash

docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
docker pull anishdchengre/dockerized_django:globally_hub

# stop existin container
docker stop dockerized_django || true
docker rm dockerized_django || true



# Deploy new container
docker run -d --name dockerized_django -p 8000:8000 anishdchengre/dockerized_django:globally_hub