@echo off
chcp 65001 >nul
echo.
echo ========================================
echo   GitLab Webhook Server Starting
echo ========================================
echo.

cd /d "%~dp0"

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found
    echo.
    echo Please install Python 3.7+
    echo Download: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [OK] Python version: %PYTHON_VERSION%

REM Set environment variables
set FEISHU_APP_ID=cli_a9e3400711fbdbcb
set FEISHU_APP_SECRET=h61QXukkibdbO0wRRFxTkgppaLvcPQFS

echo.
echo ========================================
echo   Server Information
echo ========================================
echo   Listening: http://0.0.0.0:5000
echo   Webhook URL: http://YOUR_IP:5000/gitlab-webhook
echo   Health Check: http://YOUR_IP:5000/health
echo ========================================
echo.
echo [TIP] Press Ctrl+C to stop server
echo.

python webhook_server.py

pause
