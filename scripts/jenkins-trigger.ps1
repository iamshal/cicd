# Jenkins Trigger PowerShell Script

param(
    [string]$JenkinsUrl = "http://localhost:8080",
    [string]$JobName = "cicd-demo",
    [string]$Username = "admin",
    [string]$ApiToken = "your-api-token"
)

Write-Host "=== Jenkins Trigger ===" -ForegroundColor Green

# Function to trigger Jenkins job
function Invoke-JenkinsJob {
    param(
        [string]$Url,
        [string]$Job,
        [string]$User,
        [string]$Token
    )
    
    $uri = "$Url/job/$Job/build"
    $auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$User`:$Token"))
    
    try {
        Write-Host "Triggering Jenkins job: $Job" -ForegroundColor Yellow
        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers @{Authorization="Basic $auth"}
        Write-Host "Jenkins job triggered successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error triggering Jenkins job: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to check Jenkins job status
function Get-JenkinsJobStatus {
    param(
        [string]$Url,
        [string]$Job,
        [string]$User,
        [string]$Token
    )
    
    $uri = "$Url/job/$Job/lastBuild/api/json"
    $auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$User`:$Token"))
    
    try {
        $response = Invoke-RestMethod -Uri $uri -Headers @{Authorization="Basic $auth"}
        return $response.result
    }
    catch {
        Write-Host "Error getting job status: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Trigger the job
$success = Invoke-JenkinsJob -Url $JenkinsUrl -Job $JobName -User $Username -Token $ApiToken

if ($success) {
    Write-Host "`nWaiting for job to start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    
    # Check job status
    $status = Get-JenkinsJobStatus -Url $JenkinsUrl -Job $JobName -User $Username -Token $ApiToken
    if ($status) {
        Write-Host "Job Status: $status" -ForegroundColor Cyan
        Write-Host "View job at: $JenkinsUrl/job/$JobName" -ForegroundColor Cyan
    }
}
