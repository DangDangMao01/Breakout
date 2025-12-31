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
