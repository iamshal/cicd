#!/bin/bash

echo "Building application..."
mvn clean package -DskipTests

echo "Building Docker image..."
docker build -t cicd-demo:latest .

echo "Build completed!"
