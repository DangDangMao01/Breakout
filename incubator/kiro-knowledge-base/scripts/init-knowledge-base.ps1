# Initialize knowledge-base in current project
param([string]$CentralPath)

Write-Host "Initializing knowledge-base in current project..." -ForegroundColor Cyan

$dirs = @(
    "knowledge-base\discussions",
    "knowledge-base\solutions",
    "knowledge-base\notes",
    ".kiro\hooks"
)

foreach ($dir in $dirs) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  Created: $dir" -ForegroundColor Green
    }
}

# Create gitkeep files
foreach ($sub in @("discussions", "solutions", "notes")) {
    $gitkeep = "knowledge-base\$sub\.gitkeep"
    if (!(Test-Path $gitkeep)) { "" | Out-File -FilePath $gitkeep -Encoding UTF8 }
}

Write-Host ""
Write-Host "Done! Now add Hook in Kiro:" -ForegroundColor Cyan
Write-Host "  1. Click + in Agent Hooks panel" -ForegroundColor Yellow
Write-Host "  2. Enter: auto save kb" -ForegroundColor Yellow

if ($CentralPath) {
    Write-Host ""
    Write-Host "Sync command:" -ForegroundColor Cyan
    Write-Host "  powershell -File `"$CentralPath\.kiro\scripts\sync-to-central.ps1`" -CentralPath `"$CentralPath\knowledge-base`"" -ForegroundColor Yellow
}
