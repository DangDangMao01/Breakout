@echo off
chcp 65001 >nul
echo ========================================
echo   测试 GitLab Webhook 服务器
echo ========================================
echo.

cd /d "%~dp0"

REM 检查 Python 是否安装
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Python，请先安装 Python 3.7+
    pause
    exit /b 1
)

REM 检查依赖是否安装
python -c "import requests" >nul 2>&1
if errorlevel 1 (
    echo [安装] 正在安装 requests...
    pip install requests
)

echo [提示] 请确保 Webhook 服务器已启动
echo [提示] 如果未启动，请先运行 "启动Webhook服务器.bat"
echo.
pause

python 测试Webhook.py
