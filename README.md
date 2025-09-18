# CI/CD Demo Project

A simple Spring Boot application demonstrating CI/CD practices.

## Project Structure

```
├── src/
│   ├── main/java/com/example/cicddemo/
│   │   ├── CicdDemoApplication.java
│   │   └── controller/
│   │       └── HelloController.java
│   └── test/java/com/example/cicddemo/controller/
│       └── HelloControllerTest.java
├── .github/workflows/
│   └── ci-cd.yml
├── scripts/
│   ├── build.sh
│   ├── deploy.sh
│   └── test.sh
├── Dockerfile
├── pom.xml
└── README.md
```

## CI/CD Pipeline Steps

### 1. Continuous Integration (CI)
- **Trigger**: Push to main branch or pull request
- **Steps**:
  1. Checkout code
  2. Set up Java 17
  3. Cache Maven dependencies
  4. Run unit tests
  5. Build application
  6. Deploy JAR to Nexus repository

### 2. Continuous Deployment (CD)
- **Trigger**: Push to main branch (after CI passes)
- **Steps**:
  1. Build application
  2. Create Docker image
  3. Push Docker image to Nexus registry
  4. Test Docker container
  5. Deploy to environment

## Local Development

### Prerequisites
- Java 17
- Maven 3.6+
- Docker
- Nexus Repository Manager (optional)

### Running the Application

1. **Build and run with Maven**:
   ```bash
   mvn clean package
   java -jar target/cicd-demo-1.0.0.jar
   ```

2. **Build and run with Docker**:
   ```bash
   ./scripts/build.sh
   ./scripts/deploy.sh
   ```

3. **Run tests**:
   ```bash
   ./scripts/test.sh
   ```

4. **Deploy to Nexus**:
   ```bash
   ./scripts/nexus-setup.sh      # Start Nexus (first time only)
   ./scripts/deploy-to-nexus.sh  # Deploy JAR to Nexus
   ./scripts/docker-nexus.sh     # Deploy Docker image to Nexus
   ```

### Endpoints
- `GET /` - Hello message
- `GET /health` - Health check

## CI/CD Concepts Explained

### Continuous Integration (CI)
- **Purpose**: Automatically test and validate code changes
- **Benefits**: Early bug detection, consistent builds
- **Tools**: GitHub Actions, Jenkins, GitLab CI

### Continuous Deployment (CD)
- **Purpose**: Automatically deploy validated code to production
- **Benefits**: Faster releases, reduced manual errors
- **Tools**: Docker, Kubernetes, AWS/GCP deployment tools

### Key Components
1. **Source Control**: Git repository
2. **Build Automation**: Maven/Gradle
3. **Testing**: Unit tests, integration tests
4. **Containerization**: Docker
5. **Deployment**: Automated deployment scripts
6. **Monitoring**: Health checks, logging

## Nexus Integration

### What is Nexus?
Nexus Repository Manager is a repository manager that:
- Stores and manages your application artifacts (JAR files)
- Acts as a Docker registry for container images
- Provides a central location for all your dependencies
- Enables version control and artifact management

### Nexus Setup
1. **Start Nexus**:
   ```bash
   ./scripts/nexus-setup.sh
   ```

2. **Access Nexus UI**: http://localhost:8081
   - Username: `admin`
   - Password: `admin123`

3. **Configure Repositories**:
   - Maven releases: `maven-releases`
   - Maven snapshots: `maven-snapshots`
   - Docker registry: `docker-registry`

### GitHub Secrets Configuration
Add these secrets to your GitHub repository:
- `NEXUS_URL`: Your Nexus URL (e.g., `http://your-nexus-server:8081`)
- `NEXUS_USERNAME`: Nexus username
- `NEXUS_PASSWORD`: Nexus password

## Best Practices

1. **Small, frequent commits**
2. **Comprehensive testing**
3. **Infrastructure as code**
4. **Automated rollbacks**
5. **Environment parity**
6. **Security scanning**
7. **Artifact versioning in Nexus**
8. **Docker image tagging strategy**
