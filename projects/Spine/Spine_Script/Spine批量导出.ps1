# ============================================
# Spine 批量导出脚本 (PowerShell 版)
# 完美支持中文路径
# ============================================

# ---------- 配置区域 ----------

# Spine 安装路径（请根据实际情况修改）
$SpinePath = "C:\Program Files\Spine\Spine.exe"

# 输入文件夹（留空则弹出选择对话框）
$InputFolder = ""

# 输出文件夹（留空则使用输入文件夹下的 Export 子目录）
$OutputFolder = ""

# 导出格式: json 或 binary
$ExportFormat = "json"

# 是否打包图集
$PackAtlas = $true

# 是否清理输出目录
$CleanOutput = $false

# ---------- 脚本开始 ----------

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       Spine 批量导出工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Spine 是否存在
if (-not (Test-Path $SpinePath)) {
    Write-Host "[错误] 找不到 Spine: $SpinePath" -ForegroundColor Red
    Write-Host "请修改脚本中的 SpinePath 变量" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

# 如果未设置输入文件夹，弹出文件夹选择对话框
if ([string]::IsNullOrEmpty($InputFolder)) {
    Add-Type -AssemblyName System.Windows.Forms
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "请选择包含 .spine 文件的文件夹"
    $folderBrowser.ShowNewFolderButton = $false
    
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $InputFolder = $folderBrowser.SelectedPath
    } else {
        Write-Host "[取消] 用户取消了操作" -ForegroundColor Yellow
        exit 0
    }
}

# 如果未设置输出文件夹，使用输入文件夹下的 Export 子目录
if ([string]::IsNullOrEmpty($OutputFolder)) {
    $OutputFolder = Join-Path $InputFolder "Export"
}

# 检查输入文件夹是否存在
if (-not (Test-Path $InputFolder)) {
    Write-Host "[错误] 输入文件夹不存在: $InputFolder" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

# 创建输出文件夹
if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    Write-Host "[信息] 已创建输出文件夹: $OutputFolder" -ForegroundColor Green
}

# 构建导出参数
$ExportArgs = @("--export", $ExportFormat)

if ($PackAtlas) {
    $ExportArgs += "--pack"
}

if ($CleanOutput) {
    $ExportArgs += "--clean"
}

Write-Host ""
Write-Host "[配置信息]" -ForegroundColor Cyan
Write-Host "  输入文件夹: $InputFolder"
Write-Host "  输出文件夹: $OutputFolder"
Write-Host "  导出格式: $ExportFormat"
Write-Host "  打包图集: $PackAtlas"
Write-Host "  清理输出: $CleanOutput"
Write-Host ""

# 获取所有 .spine 文件
$spineFiles = Get-ChildItem -Path $InputFolder -Filter "*.spine" -File

if ($spineFiles.Count -eq 0) {
    Write-Host "[警告] 未找到任何 .spine 文件" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 0
}

Write-Host "[开始] 共找到 $($spineFiles.Count) 个 Spine 文件" -ForegroundColor Green
Write-Host ""

# 统计
$success = 0
$failed = 0

# 批量导出
foreach ($file in $spineFiles) {
    Write-Host "正在导出: $($file.Name)" -ForegroundColor White
    
    $args = @("--input", $file.FullName, "--output", $OutputFolder) + $ExportArgs
    
    try {
        $process = Start-Process -FilePath $SpinePath -ArgumentList $args -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-Host "  [成功] $($file.Name)" -ForegroundColor Green
            $success++
        } else {
            Write-Host "  [失败] $($file.Name) (退出码: $($process.ExitCode))" -ForegroundColor Red
            $failed++
        }
    } catch {
        Write-Host "  [错误] $($file.Name): $_" -ForegroundColor Red
        $failed++
    }
    Write-Host ""
}

# 显示结果
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[完成] 导出结果统计" -ForegroundColor Cyan
Write-Host "  总计: $($spineFiles.Count) 个文件"
Write-Host "  成功: $success 个" -ForegroundColor Green
Write-Host "  失败: $failed 个" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })
Write-Host "  输出位置: $OutputFolder"
Write-Host "========================================" -ForegroundColor Cyan

# 打开输出文件夹
$openFolder = Read-Host "是否打开输出文件夹? (Y/N)"
if ($openFolder -eq "Y" -or $openFolder -eq "y") {
    Start-Process explorer.exe -ArgumentList $OutputFolder
}
