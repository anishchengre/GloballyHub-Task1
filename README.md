# GloballyHub  
*Product Development Company*  

# CI/CD Pipeline with GitHub Runner  

## Overview  
Automated pipeline for deploying Django applications using Docker and Nginx with GitHub Actions.  

## Requirements  
- GitHub repository with application code  
- Ubuntu 22.04 server  
- Docker Hub account (with repository created)  
- Self-hosted GitHub runner configured on your server  

---

## Implementation  

### 1. Server Setup Script (`server_setup.sh`)  
```bash
#!/bin/bash
# Docker installation
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    newgrp docker
    docker run hello-world
else
    echo "Docker is already installed"
fi

# Nginx installation
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
else
    echo "Nginx already installed."
fi
sudo systemctl restart nginx
```

### 2. Dependency Setup Script (`server_setup.sh`)  
```
#!/bin/bash
# a. Install project dependencies
pip install -r requirements.txt

# b. Build Docker image
docker build -t $DOCKERHUB_USERNAME/django-app:$GITHUB_SHA .

# c. Push to Docker Hub
echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
docker push $DOCKERHUB_USERNAME/django-app:$GITHUB_SHA
```



### 3. Project Setup Script (`server_setup.sh`)  
```
#!/bin/bash

docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
docker pull anishdchengre/dockerized_django:globally_hub

# stop existin container
docker stop dockerized_django || true
docker rm dockerized_django || true



# Deploy new container
docker run -d --name dockerized_django -p 8000:8000 anishdchengre/dockerized_django:globally_hub
```

### 4. Workflow Configuration (.github/workflows/deploy.yml)
```
name: CI/CD Pipeline For Globally Hub

on:
  push:
    branches: [ main ]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install dependencies and build
        run: |
          chmod +x ./dependency_setup.sh
          ./dependency_setup.sh
        env:
          DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
          DOCKERHUB_PASSWORD: ${{ secrets.DOCKERHUB_PASSWORD }}

  cd:
    needs: ci
    runs-on: self-hosted # Use self-hosted runner on your server
    steps:
      - name: Deploy to server
        run: |
          chmod +x ./project_setup.sh
          ./project_setup.sh
        env:
          DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
          DOCKERHUB_PASSWORD: ${{ secrets.DOCKERHUB_PASSWORD }}


```          