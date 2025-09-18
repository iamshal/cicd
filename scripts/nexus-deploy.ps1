# Nexus Deployment PowerShell Script

param(
    [string]$NexusUrl = "http://localhost:8081",
    [string]$Username = "admin",
    [string]$Password = "admin123",
    [string]$ArtifactId = "cicd-demo",
    [string]$Version = "1.0.0"
)

Write-Host "=== Nexus Deployment ===" -ForegroundColor Green

# Function to deploy JAR to Nexus
function Deploy-JarToNexus {
    param(
        [string]$Url,
        [string]$User,
        [string]$Pass,
        [string]$Artifact,
        [string]$Ver
    )
    
    try {
        Write-Host "Building application..." -ForegroundColor Yellow
        mvn clean package -DskipTests
        
        Write-Host "Deploying JAR to Nexus..." -ForegroundColor Yellow
        mvn deploy -DskipTests
        
        Write-Host "JAR deployed to Nexus successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error deploying JAR: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to deploy Docker image to Nexus
function Deploy-DockerToNexus {
    param(
        [string]$Url,
        [string]$User,
        [string]$Pass,
        [string]$Artifact,
        [string]$Ver
    )
    
    try {
        Write-Host "Building Docker image..." -ForegroundColor Yellow
        docker build -t "$Artifact`:$Ver" .
        
        Write-Host "Logging into Nexus Docker registry..." -ForegroundColor Yellow
        $securePassword = ConvertTo-SecureString $Pass -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential($User, $securePassword)
        
        # Login to Docker registry
        $loginCommand = "echo '$Pass' | docker login $Url -u '$User' --password-stdin"
        Invoke-Expression $loginCommand
        
        Write-Host "Tagging Docker image..." -ForegroundColor Yellow
        docker tag "$Artifact`:$Ver" "$Url/$Artifact`:$Ver"
        
        Write-Host "Pushing Docker image to Nexus..." -ForegroundColor Yellow
        docker push "$Url/$Artifact`:$Ver"
        
        Write-Host "Docker image deployed to Nexus successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error deploying Docker image: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to check Nexus connectivity
function Test-NexusConnection {
    param(
        [string]$Url,
        [string]$User,
        [string]$Pass
    )
    
    try {
        $uri = "$Url/service/rest/v1/status"
        $auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$User`:$Pass"))
        
        $response = Invoke-RestMethod -Uri $uri -Headers @{Authorization="Basic $auth"}
        Write-Host "Nexus connection successful!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error connecting to Nexus: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Main execution
Write-Host "Testing Nexus connection..." -ForegroundColor Yellow
$nexusConnected = Test-NexusConnection -Url $NexusUrl -User $Username -Pass $Password

if ($nexusConnected) {
    Write-Host "`nDeploying JAR to Nexus..." -ForegroundColor Yellow
    $jarSuccess = Deploy-JarToNexus -Url $NexusUrl -User $Username -Pass $Password -Artifact $ArtifactId -Ver $Version
    
    Write-Host "`nDeploying Docker image to Nexus..." -ForegroundColor Yellow
    $dockerSuccess = Deploy-DockerToNexus -Url $NexusUrl -User $Username -Pass $Password -Artifact $ArtifactId -Ver $Version
    
    if ($jarSuccess -and $dockerSuccess) {
        Write-Host "`nAll deployments completed successfully!" -ForegroundColor Green
        Write-Host "Check Nexus UI at: $NexusUrl" -ForegroundColor Cyan
    } else {
        Write-Host "`nSome deployments failed. Check the logs above." -ForegroundColor Red
    }
} else {
    Write-Host "Cannot connect to Nexus. Please check your configuration." -ForegroundColor Red
}
