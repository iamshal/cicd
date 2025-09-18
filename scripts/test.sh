#!/bin/bash

echo "Running tests..."
mvn test

echo "Testing application endpoints..."
curl -f http://localhost:8080/ || exit 1
curl -f http://localhost:8080/health || exit 1

echo "All tests passed!"
