#!/bin/bash

echo "Deploying to Nexus..."

# Build the application
mvn clean package -DskipTests

# Deploy to Nexus
mvn deploy -DskipTests

echo "Application deployed to Nexus!"
echo "Check Nexus UI at http://localhost:8081"
