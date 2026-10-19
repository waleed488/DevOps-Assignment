#!/usr/bin/env bash
# ====================================================================
# DevOps Lab Assignment 1: Automated Provisioning & Deployment Script
# Group: 05 | Course: DevOps (CSC418) | Section: BCS-7B
# ====================================================================

# Stop immediately if any command fails
set -e

echo "=========================================================="
echo " Starting DevOps Automated Provisioning & Deployment... "
echo "=========================================================="

# 1. Check whether Docker is installed and install it only if missing
echo "[Step 1/5] Checking Docker installation..."
if ! command -v docker > /dev/null 2>&1; then
    echo "Docker is not installed. Installing Docker..."
    if command -v dnf > /dev/null 2>&1; then
        # CentOS / RHEL / EuroLinux
        sudo dnf install -y yum-utils device-mapper-persistent-data lvm2 curl
        sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo || true
        sudo dnf install -y docker-ce docker-ce-cli containerd.io || sudo dnf install -y docker
    elif command -v apt-get > /dev/null 2>&1; then
        # Ubuntu / Debian
        sudo apt-get update -y
        sudo apt-get install -y docker.io curl
    else
        # Fallback to automated get.docker script
        curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
        sudo sh /tmp/get-docker.sh
    fi
    echo "Docker installed successfully."
else
    echo "Docker is already installed. Skipping installation."
fi

# Ensure curl is available for HTTP verification
if ! command -v curl > /dev/null 2>&1; then
    echo "Installing curl utility..."
    if command -v dnf > /dev/null 2>&1; then
        sudo dnf install -y curl
    elif command -v apt-get > /dev/null 2>&1; then
        sudo apt-get install -y curl
    fi
fi

# 2. Start and enable Docker service
echo "[Step 2/5] Starting and enabling Docker service..."
sudo systemctl enable --now docker

# 3. Check for existing devops-web container and handle it cleanly (Repeatability)
echo "[Step 3/5] Checking for existing 'devops-web' container..."
if [ "$(sudo docker ps -aq -f name=^devops-web$)" ]; then
    echo "Existing container 'devops-web' found. Removing it for fresh deployment..."
    sudo docker rm -f devops-web
else
    echo "No existing 'devops-web' container found. Proceeding with fresh deployment..."
fi

# 4. Run the nginx:alpine container
echo "[Step 4/5] Running container 'devops-web' using nginx:alpine image..."
sudo docker run -d \
    --name devops-web \
    -p 80:80 \
    -v /vagrant/website:/usr/share/nginx/html \
    nginx:alpine

# 5. Display running container and verify HTTP response
echo "[Step 5/5] Verifying container and HTTP response..."
echo "--- Running Docker Containers ---"
sudo docker ps -f name=devops-web

echo "--- HTTP Response Header Verification (curl -I http://localhost) ---"
curl -I http://localhost

echo "=========================================================="
echo " Provisioning & Deployment Completed Successfully!        "
echo " Host Access URL: http://localhost:8080                   "
echo "=========================================================="
