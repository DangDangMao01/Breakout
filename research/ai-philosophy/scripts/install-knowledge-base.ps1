# ============================================
# Kiro Knowledge Base - One-Click Installer
# ============================================
# Run this script to set up the complete knowledge base system
# Usage: powershell -File install-knowledge-base.ps1

param(
    [switch]$Silent,
    [string]$CentralPath
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "`n[$([char]0x2713)] $Message" -ForegroundColor Cyan
}

function Write-Info {
    param([string]$Message)
    Write-Host "    $Message" -ForegroundColor White
}

function Write-Success {
    param([string]$Message)
    Write-Host "    $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "    $Message" -ForegroundColor Yellow
}

# ============================================
# BANNER
# ============================================
Clear-Host
Write-Host ""
Write-Host "  ================================================" -ForegroundColor Cyan
Write-Host "    Kiro Knowledge Base Installer v1.0" -ForegroundColor Cyan
Write-Host "  ================================================" -ForegroundColor Cyan
Write-Host ""

# ============================================
# STEP 1: Determine Central Repository Path
# ============================================
Write-Step "Configuring Central Knowledge Base"

if ([string]::IsNullOrEmpty($CentralPath)) {
    $currentPath = (Get-Location).Path
    
    if (!$Silent) {
        Write-Host ""
        Write-Host "  Where do you want to store the central knowledge base?" -ForegroundColor Yellow
        Write-Host "  [1] Current folder: $currentPath" -ForegroundColor White
        Write-Host "  [2] Enter custom path" -ForegroundColor White
        Write-Host ""
        $choice = Read-Host "  Enter choice (1 or 2)"
        
        if ($choice -eq "2") {
            $CentralPath = Read-Host "  Enter full path"
        } else {
            $CentralPath = $currentPath
        }
    } else {
        $CentralPath = $currentPath
    }
}

Write-Info "Central path: $CentralPath"


# ============================================
# STEP 2: Create Directory Structure
# ============================================
Write-Step "Creating directory structure"

$dirs = @(
    "knowledge-base\discussions",
    "knowledge-base\solutions",
    "knowledge-base\notes",
    ".kiro\hooks",
    ".kiro\scripts",
    ".kiro\steering"
)

foreach ($dir in $dirs) {
    $fullPath = Join-Path $CentralPath $dir
    if (!(Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Success "Created: $dir"
    } else {
        Write-Info "Exists: $dir"
    }
}

# ============================================
# STEP 3: Create .gitkeep files
# ============================================
$gitkeepDirs = @("discussions", "solutions", "notes")
foreach ($dir in $gitkeepDirs) {
    $gitkeep = Join-Path $CentralPath "knowledge-base\$dir\.gitkeep"
    if (!(Test-Path $gitkeep)) {
        "" | Out-File -FilePath $gitkeep -Encoding UTF8
    }
}

# ============================================
# STEP 4: Create README
# ============================================
Write-Step "Creating documentation"

$readmePath = Join-Path $CentralPath "knowledge-base\README.md"
if (!(Test-Path $readmePath)) {
    $readmeContent = @"
# Kiro Knowledge Base

Central repository for all Kiro conversations and solutions.

## Structure

- **discussions/** - Problem discussions and brainstorming
- **solutions/** - Verified solutions and implementations
- **notes/** - Learning notes and tips

## Quick Start

1. Run installer: ``powershell -File .kiro/scripts/install-knowledge-base.ps1``
2. In any project, add Hook: click + in Agent Hooks, enter ``auto save kb``
3. Sync command: ``powershell -File .kiro/scripts/sync-to-central.ps1 -CentralPath <path>``

## New Device Setup

Run: ``powershell -File .kiro/scripts/setup-new-device.ps1``
"@
    Set-Content -Path $readmePath -Value $readmeContent -Encoding UTF8
    Write-Success "Created: knowledge-base/README.md"
}

# ============================================
# STEP 5: Create PROGRESS.md
# ============================================
$progressPath = Join-Path $CentralPath "knowledge-base\PROGRESS.md"
if (!(Test-Path $progressPath)) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm"
    $progressContent = @"
---
last_updated: $date
status: active
---

# Progress Tracking

## Completed

- [x] Knowledge base initialized

## In Progress

- [ ] (Add your tasks here)

## Next Steps

(Add next steps here)
"@
    Set-Content -Path $progressPath -Value $progressContent -Encoding UTF8
    Write-Success "Created: knowledge-base/PROGRESS.md"
}


# ============================================
# STEP 6: Copy Scripts
# ============================================
Write-Step "Installing scripts"

$scriptsDir = Join-Path $CentralPath ".kiro\scripts"

# Sync script
$syncScript = @'
# Sync local knowledge-base to central repository
param(
    [Parameter(Mandatory=$true)]
    [string]$CentralPath,
    [switch]$Force
)

$localPath = "knowledge-base"

if (!(Test-Path $localPath)) {
    Write-Host "Local knowledge-base not found" -ForegroundColor Red
    exit 1
}

if (!(Test-Path $CentralPath)) {
    Write-Host "Central path not found: $CentralPath" -ForegroundColor Red
    exit 1
}

$projectName = Split-Path -Leaf (Get-Location)
Write-Host "Syncing to central repository..." -ForegroundColor Cyan
Write-Host "  From: $localPath"
Write-Host "  To: $CentralPath"
Write-Host "  Project: $projectName"

$folders = @("discussions", "solutions", "notes")
$syncCount = 0

foreach ($folder in $folders) {
    $sourcePath = Join-Path $localPath $folder
    $destPath = Join-Path $CentralPath $folder
    
    if (Test-Path $sourcePath) {
        $files = Get-ChildItem -Path $sourcePath -Filter "*.md" -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            if ($file.Name -eq "README.md" -or $file.Name -eq ".gitkeep") { continue }
            
            $newName = "$projectName-$($file.Name)"
            $destFile = Join-Path $destPath $newName
            
            if (!(Test-Path $destFile)) {
                Copy-Item $file.FullName -Destination $destFile -Force
                Write-Host "  Synced: $folder/$($file.Name)" -ForegroundColor Green
                $syncCount++
            } elseif ($Force) {
                Copy-Item $file.FullName -Destination $destFile -Force
                Write-Host "  Updated: $folder/$($file.Name)" -ForegroundColor Yellow
                $syncCount++
            } else {
                Write-Host "  Skipped (exists): $folder/$($file.Name)" -ForegroundColor Gray
            }
        }
    }
}

Write-Host ""
Write-Host "Sync complete! $syncCount files synced." -ForegroundColor Cyan
'@

Set-Content -Path "$scriptsDir\sync-to-central.ps1" -Value $syncScript -Encoding UTF8
Write-Success "Created: sync-to-central.ps1"

# Generate index script
$indexScript = @'
# Generate knowledge-base index
param([string]$BasePath = "knowledge-base")

$indexFile = "$BasePath\INDEX.md"

Write-Host "Generating index..." -ForegroundColor Cyan

$allFiles = @()
$folders = @("discussions", "solutions", "notes")

foreach ($folder in $folders) {
    $folderPath = Join-Path $BasePath $folder
    if (Test-Path $folderPath) {
        $files = Get-ChildItem -Path $folderPath -Filter "*.md" -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            if ($file.Name -match "^(README|\.gitkeep)") { continue }
            
            $content = Get-Content $file.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
            
            $tags = @()
            $domain = "other"
            
            if ($content -match "tags:\s*\[([^\]]+)\]") {
                $tags = $matches[1] -split ",\s*"
            }
            if ($content -match "domain:\s*(\w+)") {
                $domain = $matches[1]
            }
            
            $allFiles += [PSCustomObject]@{
                Name = $file.Name
                Path = "$folder/$($file.Name)"
                Folder = $folder
                Tags = $tags
                Domain = $domain
            }
        }
    }
}

$date = Get-Date -Format "yyyy-MM-dd HH:mm"
$indexContent = "# Knowledge Base Index`n`n> Generated: $date`n`n"

$indexContent += "## By Domain`n"
$domains = $allFiles | Group-Object -Property Domain
foreach ($domainGroup in $domains) {
    $indexContent += "`n### $($domainGroup.Name)`n`n"
    foreach ($file in $domainGroup.Group) {
        $tagStr = ""
        if ($file.Tags.Count -gt 0) {
            $tagStr = " ``" + ($file.Tags -join "`` ``") + "``"
        }
        $indexContent += "- [$($file.Name)]($($file.Path))$tagStr`n"
    }
}

$indexContent += "`n## By Type`n"
foreach ($folder in $folders) {
    $folderFiles = $allFiles | Where-Object { $_.Folder -eq $folder }
    if ($folderFiles.Count -gt 0) {
        $indexContent += "`n### $folder`n`n"
        foreach ($file in $folderFiles) {
            $indexContent += "- [$($file.Name)]($($file.Path))`n"
        }
    }
}

Set-Content -Path $indexFile -Value $indexContent -Encoding UTF8
Write-Host "Index generated: $indexFile" -ForegroundColor Green
Write-Host "Total files: $($allFiles.Count)" -ForegroundColor White
'@

Set-Content -Path "$scriptsDir\generate-index.ps1" -Value $indexScript -Encoding UTF8
Write-Success "Created: generate-index.ps1"

# Init script for other projects
$initScript = @'
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
'@

Set-Content -Path "$scriptsDir\init-knowledge-base.ps1" -Value $initScript -Encoding UTF8
Write-Success "Created: init-knowledge-base.ps1"


# ============================================
# STEP 7: Setup Global Steering Rules
# ============================================
Write-Step "Configuring global Kiro settings"

$userSteeringDir = "$env:USERPROFILE\.kiro\steering"
if (!(Test-Path $userSteeringDir)) {
    New-Item -ItemType Directory -Path $userSteeringDir -Force | Out-Null
    Write-Success "Created: ~/.kiro/steering/"
}

$globalSteering = @"
---
inclusion: always
---

# Knowledge Base System - Smart Retrieval & Save

## CENTRAL KNOWLEDGE BASE

Path: ``$CentralPath\knowledge-base``
Index: ``$CentralPath\knowledge-base\INDEX.md``

---

## STEP 1: ON USER QUESTION (Check First)

1. Read ``$CentralPath\knowledge-base\INDEX.md``
2. Search for related keywords
3. **If MATCH:** Read file, show summary, ask "Apply this solution?"
4. **If NO match:** Answer normally, then save (Step 2)

---

## STEP 2: ON AGENT COMPLETE (Auto-Save)

Save optimized solution with YAML front-matter to knowledge-base/

---

## STEP 3: ON SESSION END / USER PAUSE

1. Save unfinished work to discussions/
2. Update PROGRESS.md
3. Run: ``powershell -File "$CentralPath\.kiro\scripts\generate-index.ps1"``

---

## STEP 4: SESSION START

Check PROGRESS.md for ``- [ ]`` items, ask to continue if found.

---

## STEP 5: ON ERROR / ISSUE FOUND (Auto-Report)

Run: ``powershell -File "$CentralPath\.kiro\scripts\report-test-issue.ps1" -Issue "描述" -Severity "medium"``

---

## COMMANDS

Sync: ``powershell -File "$CentralPath\.kiro\scripts\sync-to-central.ps1" -CentralPath "$CentralPath\knowledge-base"``

Index: ``powershell -File "$CentralPath\.kiro\scripts\generate-index.ps1"``
"@

Set-Content -Path "$userSteeringDir\check-knowledge-base.md" -Value $globalSteering -Encoding UTF8
Write-Success "Created global steering rule"

# ============================================
# STEP 8: Create workspace steering
# ============================================
$workspaceSteering = @"
---
inclusion: always
---

# Knowledge Base - Auto Save

This workspace has knowledge-base auto-save enabled via global steering rules.

No manual Hook setup required - Kiro will automatically save valuable content.
"@

$workspaceSteeringDir = Join-Path $CentralPath ".kiro\steering"
if (!(Test-Path $workspaceSteeringDir)) {
    New-Item -ItemType Directory -Path $workspaceSteeringDir -Force | Out-Null
}
Set-Content -Path "$workspaceSteeringDir\check-hook-setup.md" -Value $workspaceSteering -Encoding UTF8
Write-Success "Created workspace steering rule"

# ============================================
# STEP 9: Save Configuration & Install Log
# ============================================
Write-Step "Saving configuration"

$configPath = Join-Path $CentralPath ".kiro\kb-config.json"
$config = @{
    version = "1.0"
    centralPath = $CentralPath
    installedAt = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    device = $env:COMPUTERNAME
} | ConvertTo-Json

Set-Content -Path $configPath -Value $config -Encoding UTF8
Write-Success "Saved configuration to .kiro/kb-config.json"

# Create install log in knowledge-base
$logDate = Get-Date -Format "yyyyMMdd-HHmmss"
$logPath = Join-Path $CentralPath "knowledge-base\notes\install-log-$logDate.md"
$logContent = @"
---
date: $(Get-Date -Format "yyyy-MM-dd")
domain: kiro
tags: [install, log, setup]
status: completed
---

# Installation Log

## Device Info
- Computer: $env:COMPUTERNAME
- User: $env:USERNAME
- Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Installation Path
- Central Path: $CentralPath
- Knowledge Base: $CentralPath\knowledge-base

## Created Items
- Directory structure: OK
- Scripts: OK
- Global Steering: OK
- Workspace Steering: OK
- Config file: OK

## Next Steps
- [ ] Test knowledge retrieval in new conversation
- [ ] Test auto-save on agent complete
- [ ] Test cross-project sync

## Issues Found
(Kiro will auto-record issues here)
"@

Set-Content -Path $logPath -Value $logContent -Encoding UTF8
Write-Success "Created install log: install-log-$logDate.md"

# ============================================
# COMPLETE
# ============================================
Write-Host ""
Write-Host "  ================================================" -ForegroundColor Green
Write-Host "    Installation Complete!" -ForegroundColor Green
Write-Host "  ================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Central Knowledge Base: $CentralPath\knowledge-base" -ForegroundColor White
Write-Host ""
Write-Host "  HOW IT WORKS:" -ForegroundColor Cyan
Write-Host "  - Kiro will auto-save valuable conversations" -ForegroundColor White
Write-Host "  - No manual setup needed - just start chatting!" -ForegroundColor White
Write-Host ""
Write-Host "  OPTIONAL - Add Hook for extra reminders:" -ForegroundColor Gray
Write-Host "  Click + in Agent Hooks, enter: auto save kb" -ForegroundColor Gray
Write-Host ""
Write-Host "  COMMANDS:" -ForegroundColor Yellow
Write-Host "  Generate index:" -ForegroundColor White
Write-Host "    powershell -File `"$CentralPath\.kiro\scripts\generate-index.ps1`"" -ForegroundColor Gray
Write-Host ""
Write-Host "  Sync from other project:" -ForegroundColor White
Write-Host "    powershell -File `"$CentralPath\.kiro\scripts\sync-to-central.ps1`" -CentralPath `"$CentralPath\knowledge-base`"" -ForegroundColor Gray
Write-Host ""
