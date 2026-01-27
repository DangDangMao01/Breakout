# New Device Setup Script
# Run this after cloning the central repository on a new device

param(
    [string]$CentralPath = (Get-Location).Path
)

Write-Host "Setting up Kiro Knowledge Base on new device..." -ForegroundColor Cyan
Write-Host "Central repository path: $CentralPath" -ForegroundColor White

# Create user-level steering directory
$steeringDir = "$env:USERPROFILE\.kiro\steering"
if (!(Test-Path $steeringDir)) {
    New-Item -ItemType Directory -Path $steeringDir -Force | Out-Null
    Write-Host "  Created: $steeringDir" -ForegroundColor Green
}

# Create steering rule with current path
$steeringContent = @"
---
inclusion: always
---

# Knowledge Base System

## Quick Setup for New Projects

Tell user: "To enable auto-save, click + in Agent Hooks and enter: **auto save kb**"

## Sync Command (use this device's path)

``````powershell
powershell -File "$CentralPath\.kiro\scripts\sync-to-central.ps1" -CentralPath "$CentralPath\knowledge-base"
``````

## On agent completion with valuable content

Save to knowledge-base/ with tags, then remind user to run sync command above.
"@

$steeringFile = "$steeringDir\check-knowledge-base.md"
Set-Content -Path $steeringFile -Value $steeringContent -Encoding UTF8
Write-Host "  Created: $steeringFile" -ForegroundColor Green

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Open any project in Kiro"
Write-Host "2. Click + in Agent Hooks panel"
Write-Host "3. Enter: auto save kb"
Write-Host ""
Write-Host "Sync command for this device:" -ForegroundColor Yellow
Write-Host "powershell -File `"$CentralPath\.kiro\scripts\sync-to-central.ps1`" -CentralPath `"$CentralPath\knowledge-base`""
