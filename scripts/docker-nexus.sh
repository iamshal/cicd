#!/bin/bash

echo "Building and pushing Docker image to Nexus..."

# Build Docker image
docker build -t cicd-demo:latest .

# Login to Nexus Docker registry
echo "admin123" | docker login localhost:8081 -u admin --password-stdin

# Tag and push image
docker tag cicd-demo:latest localhost:8081/cicd-demo:latest
docker push localhost:8081/cicd-demo:latest

echo "Docker image pushed to Nexus!"
echo "Check Nexus UI at http://localhost:8081"
