# Spine 批量导出指南

## 方案：使用 Spine 命令行导出

Spine 提供了命令行工具，可以批量处理 `.spine` 项目文件。

## 基本用法

```batch
:: 导出单个文件为 JSON + 图集
spine --input "C:\SpineProjects\character.spine" --output "C:\Export" --export json

:: 批量导出整个文件夹
for %f in (C:\SpineProjects\*.spine) do spine --input "%f" --output "C:\Export" --export json
```

## PowerShell 批量脚本

```powershell
$spinePath = "C:\Program Files\Spine\Spine.exe"  # Spine 安装路径
$inputFolder = "C:\SpineProjects"
$outputFolder = "C:\Export"

Get-ChildItem -Path $inputFolder -Filter "*.spine" | ForEach-Object {
    & $spinePath --input $_.FullName --output $outputFolder --export json
    Write-Host "Exported: $($_.Name)"
}
```

## 常用导出参数

| 参数 | 说明 |
|------|------|
| `--export json` | 导出 JSON 格式 |
| `--export binary` | 导出二进制 (.skel) |
| `--pack` | 打包图集 |
| `--clean` | 导出前清理输出目录 |

## 使用前需要确认

1. Spine 安装路径
2. 项目文件夹位置
3. 导出格式 (JSON/Binary)
4. 是否需要打包图集

## 参考资源

- Spine 官方命令行文档: http://esotericsoftware.com/spine-command-line-interface
