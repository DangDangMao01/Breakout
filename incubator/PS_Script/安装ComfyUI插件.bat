@echo off
chcp 65001 >nul

echo ========================================
echo   ComfyUI 插件安装脚本
echo ========================================
echo.

set CUSTOM_NODES=D:\Program Files\ComfyUI_windows_portable\ComfyUI\custom_nodes

cd /d "%CUSTOM_NODES%"

echo [1/2] 正在安装 ComfyUI-Manager...
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
echo.

echo [2/2] 正在安装 ComfyUI-Copilot...
git clone https://github.com/AIDC-AI/ComfyUI-Copilot.git
echo.

echo ========================================
echo 安装完成！请重启 ComfyUI 生效
echo ========================================
pause
