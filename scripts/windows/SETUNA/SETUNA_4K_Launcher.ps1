# SETUNA 4K 启动器
# 设置 DPI 感知后启动 SETUNA

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class DpiHelper {
    [DllImport("user32.dll")]
    public static extern bool SetProcessDPIAware();
    
    [DllImport("shcore.dll")]
    public static extern int SetProcessDpiAwareness(int value);
}
"@

# 设置 DPI 感知（2 = Per-Monitor DPI Aware）
try {
    [DpiHelper]::SetProcessDpiAwareness(2)
} catch {
    [DpiHelper]::SetProcessDPIAware()
}

# 启动 SETUNA
$setunaPath = Join-Path $PSScriptRoot "SETUNA.exe"
Start-Process $setunaPath
