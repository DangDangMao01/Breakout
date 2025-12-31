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
