#!/bin/bash

echo "Stopping existing container..."
docker stop cicd-demo 2>/dev/null || true
docker rm cicd-demo 2>/dev/null || true

echo "Starting new container..."
docker run -d -p 8080:8080 --name cicd-demo cicd-demo:latest

echo "Waiting for application to start..."
sleep 10

echo "Testing application..."
curl -f http://localhost:8080/health || exit 1

echo "Deployment completed!"
