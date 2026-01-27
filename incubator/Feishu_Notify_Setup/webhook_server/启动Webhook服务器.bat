@echo off
chcp 65001 >nul
echo ========================================
echo   GitLab Webhook 服务器启动
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
echo [检查] 检查依赖...
python -c "import flask" >nul 2>&1
if errorlevel 1 (
    echo [安装] 正在安装依赖...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [错误] 依赖安装失败
        pause
        exit /b 1
    )
)

REM 设置环境变量
set FEISHU_APP_ID=cli_a9e3400711fbdbcb
set FEISHU_APP_SECRET=h61QXukkibdbO0wRRFxTkgppaLvcPQFS

echo [启动] 正在启动 Webhook 服务器...
echo.
echo ========================================
echo   服务器信息
echo ========================================
echo   监听地址: http://0.0.0.0:5000
echo   Webhook URL: http://你的服务器IP:5000/gitlab-webhook
echo   健康检查: http://你的服务器IP:5000/health
echo ========================================
echo.
echo [提示] 按 Ctrl+C 停止服务器
echo.

python webhook_server.py

pause
