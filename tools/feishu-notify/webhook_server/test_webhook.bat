@echo off
chcp 65001 >nul
echo.
echo ========================================
echo   Test GitLab Webhook Server
echo ========================================
echo.

cd /d "%~dp0"

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found
    pause
    exit /b 1
)

REM Check requests
python -c "import requests" >nul 2>&1
if errorlevel 1 (
    echo [INSTALL] Installing requests...
    pip install requests
)

echo [TIP] Make sure Webhook server is running
echo [TIP] If not, run "start_server.bat" first
echo.
pause

python 测试Webhook.py

pause
