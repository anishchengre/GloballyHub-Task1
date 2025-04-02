#!/bin/bash
set -euo pipefail #Exit on error, undefined variables, and pipelline features


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

# Install Nginx (if not exists)
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