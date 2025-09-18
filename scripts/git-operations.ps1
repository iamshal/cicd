# Git Operations PowerShell Script

param(
    [string]$CommitMessage = "Update from CI/CD pipeline",
    [string]$Branch = "main"
)

Write-Host "=== Git Operations ===" -ForegroundColor Green

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    git init
    git branch -M main
}

# Add all changes
Write-Host "Adding all changes..." -ForegroundColor Yellow
git add .

# Check if there are changes to commit
$status = git status --porcelain
if ($status) {
    Write-Host "Committing changes..." -ForegroundColor Yellow
    git commit -m $CommitMessage
    
    # Push to remote
    Write-Host "Pushing to remote repository..." -ForegroundColor Yellow
    git push origin $Branch
    
    Write-Host "Git operations completed successfully!" -ForegroundColor Green
} else {
    Write-Host "No changes to commit." -ForegroundColor Yellow
}

# Show current status
Write-Host "`nCurrent Git Status:" -ForegroundColor Cyan
git status
