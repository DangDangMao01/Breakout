# ============================================
# Test Issue Reporter
# 测试问题自动回传到开发项目
# ============================================
# Usage: powershell -File report-test-issue.ps1 -Issue "问题描述" -Severity "high/medium/low"

param(
    [Parameter(Mandatory=$true)]
    [string]$Issue,
    
    [ValidateSet("high", "medium", "low")]
    [string]$Severity = "medium",
    
    [string]$Steps = "",
    
    [string]$DevProjectPath = "E:\K_Kiro_Work"
)

$issuesLogPath = "$DevProjectPath\knowledge-base\notes\issues-log.md"

if (!(Test-Path $issuesLogPath)) {
    Write-Host "Issues log not found: $issuesLogPath" -ForegroundColor Red
    exit 1
}

$date = Get-Date -Format "yyyy-MM-dd HH:mm"
$projectName = Split-Path -Leaf (Get-Location)
$issueId = Get-Date -Format "yyyyMMddHHmmss"

# Read current content
$content = Get-Content $issuesLogPath -Raw -Encoding UTF8

# Add to Open Issues table
$newRow = "| $issueId | $date | $Issue | $Severity | open |"
$content = $content -replace "(\| # \| Date \| Issue \| Severity \| Status \|`n\|---\|------\|-------\|----------\|--------\|)", "`$1`n$newRow"

# Add detail section
$detailSection = @"

---

### Issue #$issueId

- **Date:** $date
- **Project:** $projectName
- **Severity:** $Severity
- **Status:** open

**Description:**
$Issue

**Steps to Reproduce:**
$Steps

**Notes:**
(Kiro will add fix notes here)
"@

$content = $content + $detailSection

Set-Content -Path $issuesLogPath -Value $content -Encoding UTF8

Write-Host "Issue reported successfully!" -ForegroundColor Green
Write-Host "  ID: $issueId" -ForegroundColor White
Write-Host "  Logged to: $issuesLogPath" -ForegroundColor Gray
