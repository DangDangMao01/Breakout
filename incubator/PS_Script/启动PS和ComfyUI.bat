@echo off
chcp 65001 >nul

:: ============================================
::  PS + ComfyUI 联合启动器
:: ============================================
::
::  【使用说明】
::  1. 修改下方【配置区域】的两个路径
::  2. 双击运行此脚本即可同时启动 ComfyUI 和 Photoshop
::
::  【配置区域】- 根据实际安装路径修改
:: ============================================
set COMFYUI_DIR=D:\Program Files\ComfyUI_windows_portable
set PS_PATH=C:\Program Files\Adobe\Adobe Photoshop 2026\Photoshop.exe
:: ============================================
::
::  【常见问题】
::
::  Q1: 提示 "'D:\Program' 不是内部或外部命令"
::  A1: 路径包含空格导致，本脚本已处理此问题，确保路径用引号包裹
::
::  Q2: 提示 "Windows 找不到文件 'ComfyUI'"
::  A2: 不要直接调用 python 启动 ComfyUI，应使用 ComfyUI 自带的
::      run_nvidia_gpu.bat 启动脚本
::
::  Q3: ComfyUI 窗口显示 "内存不足" 或启动失败
::  A3: 必须使用 ComfyUI 自带的 run_nvidia_gpu.bat 启动
::      不要用 python main.py 方式启动，会缺少环境变量配置
::
::  Q4: 如何找到正确的路径？
::  A4: - ComfyUI: 找到 run_nvidia_gpu.bat 所在的文件夹
::      - Photoshop: 右键 PS 快捷方式 -> 属性 -> 目标
::
:: ============================================

echo ========================================
echo   PS + ComfyUI 联合启动器
echo ========================================
echo.

:: 检查 ComfyUI 路径
if not exist "%COMFYUI_DIR%\run_nvidia_gpu.bat" (
    echo 错误: 找不到 ComfyUI
    echo 请修改脚本中的 COMFYUI_DIR 路径
    echo 当前路径: %COMFYUI_DIR%
    pause
    exit /b 1
)

:: 检查 Photoshop 路径
if not exist "%PS_PATH%" (
    echo 错误: 找不到 Photoshop
    echo 请修改脚本中的 PS_PATH 路径
    echo 当前路径: %PS_PATH%
    pause
    exit /b 1
)

echo 正在启动 ComfyUI...
cd /d "%COMFYUI_DIR%"
start "" "run_nvidia_gpu.bat"

echo 等待 ComfyUI 完全启动 (约30秒)...
timeout /t 30 /nobreak

echo.
echo 正在启动 Photoshop...
start "" "%PS_PATH%"

echo.
echo ========================================
echo 启动完成！
echo ComfyUI 地址: http://127.0.0.1:8188
echo ========================================
timeout /t 3 >nul
