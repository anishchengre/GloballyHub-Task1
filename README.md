# GloballyHub
Product Development Company


# CI/CD Pipeline with GitHub Runner

## Overview
Pipeline for deploying Django app using Docker and Nginx


## Requirements
- GitHub repository with code
- Linux server (Ubuntu 22.04)
- Docker Hub account



## Implementation Steps

### 1. Server Setup Script (`server_setup.sh`)
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


## Implementation Steps


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

    