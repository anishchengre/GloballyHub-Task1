#!/bin/bash

docker build -t anishdchengre/dockerized_django:globally_hub .

docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
docker push anishdchengre/dockerized_django:globally_hub