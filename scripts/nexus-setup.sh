#!/bin/bash

echo "Setting up Nexus Repository Manager..."

# Start Nexus with Docker
docker run -d -p 8081:8081 --name nexus sonatype/nexus3

echo "Waiting for Nexus to start..."
sleep 60

echo "Nexus is running at http://localhost:8081"
echo "Default credentials: admin / admin123"
echo "You can now configure repositories in Nexus UI"
