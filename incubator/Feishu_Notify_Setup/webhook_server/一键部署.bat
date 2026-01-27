@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ========================================
echo   GitLab Webhook 飞书通知 - 一键部署
echo ========================================
echo.

cd /d "%~dp0"

REM ============================================
REM 步骤 1: 环境检查
REM ============================================
echo [步骤 1/5] 环境检查
echo ----------------------------------------

REM 检查 Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Python
    echo.
    echo 请先安装 Python 3.7 或更高版本
    echo 下载地址: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [成功] Python 版本: %PYTHON_VERSION%

REM 检查 pip
pip --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 pip
    echo.
    pause
    exit /b 1
)
echo [成功] pip 已安装

echo.

REM ============================================
REM 步骤 2: 安装依赖
REM ============================================
echo [步骤 2/5] 安装依赖
echo ----------------------------------------

REM 检查 Flask 是否已安装
python -c "import flask" >nul 2>&1
if errorlevel 1 (
    echo [安装] 正在安装 Flask...
    pip install Flask==3.0.0 -i https://pypi.tuna.tsinghua.edu.cn/simple
    if errorlevel 1 (
        echo [错误] Flask 安装失败
        pause
        exit /b 1
    )
    echo [成功] Flask 安装完成
) else (
    echo [跳过] Flask 已安装
)

REM 检查 requests 是否已安装
python -c "import requests" >nul 2>&1
if errorlevel 1 (
    echo [安装] 正在安装 requests...
    pip install requests==2.31.0 -i https://pypi.tuna.tsinghua.edu.cn/simple
    if errorlevel 1 (
        echo [错误] requests 安装失败
        pause
        exit /b 1
    )
    echo [成功] requests 安装完成
) else (
    echo [跳过] requests 已安装
)

echo.

REM ============================================
REM 步骤 3: 获取本机 IP 地址
REM ============================================
echo [步骤 3/5] 获取本机 IP 地址
echo ----------------------------------------

REM 获取本机 IP（优先获取以太网，其次 Wi-Fi）
set LOCAL_IP=
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set IP=%%a
    set IP=!IP: =!
    REM 排除 127.0.0.1
    if not "!IP!"=="127.0.0.1" (
        if not defined LOCAL_IP (
            set LOCAL_IP=!IP!
        )
    )
)

if not defined LOCAL_IP (
    echo [警告] 无法自动获取 IP 地址
    set LOCAL_IP=localhost
)

echo [检测] 本机 IP: %LOCAL_IP%
echo.

REM ============================================
REM 步骤 4: 配置检查
REM ============================================
echo [步骤 4/5] 配置检查
echo ----------------------------------------

REM 检查 owners.json 是否存在
if not exist "..\config\owners.json" (
    echo [警告] 未找到 owners.json 配置文件
    echo [提示] 请先配置项目负责人
    echo.
    echo 配置文件位置: ..\config\owners.json
    echo.
    pause
    exit /b 1
)

echo [成功] 配置文件已存在
echo.

REM ============================================
REM 步骤 5: 生成部署信息
REM ============================================
echo [步骤 5/5] 生成部署信息
echo ----------------------------------------

REM 创建部署信息文件
echo # GitLab Webhook 部署信息 > 部署信息.txt
echo. >> 部署信息.txt
echo 部署时间: %date% %time% >> 部署信息.txt
echo 服务器 IP: %LOCAL_IP% >> 部署信息.txt
echo Python 版本: %PYTHON_VERSION% >> 部署信息.txt
echo. >> 部署信息.txt
echo ## Webhook URL >> 部署信息.txt
echo. >> 部署信息.txt
echo 请在 GitLab 项目中配置以下 Webhook URL: >> 部署信息.txt
echo. >> 部署信息.txt
echo     http://%LOCAL_IP%:5000/gitlab-webhook >> 部署信息.txt
echo. >> 部署信息.txt
echo ## 配置步骤 >> 部署信息.txt
echo. >> 部署信息.txt
echo 1. 打开 GitLab 项目页面 >> 部署信息.txt
echo 2. 进入 Settings -^> Webhooks >> 部署信息.txt
echo 3. 填写 URL: http://%LOCAL_IP%:5000/gitlab-webhook >> 部署信息.txt
echo 4. Secret Token: 留空 >> 部署信息.txt
echo 5. Trigger: 勾选 Push events >> 部署信息.txt
echo 6. SSL verification: 取消勾选（内网 HTTP） >> 部署信息.txt
echo 7. 点击 Add webhook >> 部署信息.txt
echo 8. 点击 Test -^> Push events 测试 >> 部署信息.txt
echo. >> 部署信息.txt
echo ## 健康检查 >> 部署信息.txt
echo. >> 部署信息.txt
echo 在浏览器中打开: http://%LOCAL_IP%:5000/health >> 部署信息.txt
echo 如果看到 {"status": "ok"}，说明服务器正常运行 >> 部署信息.txt
echo. >> 部署信息.txt

echo [成功] 部署信息已保存到: 部署信息.txt
echo.

REM ============================================
REM 部署完成
REM ============================================
echo ========================================
echo   部署完成！
echo ========================================
echo.
echo [服务器信息]
echo   本机 IP: %LOCAL_IP%
echo   监听端口: 5000
echo   Webhook URL: http://%LOCAL_IP%:5000/gitlab-webhook
echo   健康检查: http://%LOCAL_IP%:5000/health
echo.
echo [下一步操作]
echo   1. 运行 "启动Webhook服务器.bat" 启动服务器
echo   2. 在 GitLab 中配置 Webhook（详见 部署信息.txt）
echo   3. 运行 "测试Webhook.bat" 测试功能
echo.
echo [配置文件]
echo   项目负责人配置: ..\config\owners.json
echo   部署信息: 部署信息.txt
echo.
echo ========================================

REM 询问是否立即启动服务器
echo.
set /p START_SERVER="是否立即启动 Webhook 服务器？(Y/N): "
if /i "%START_SERVER%"=="Y" (
    echo.
    echo [启动] 正在启动 Webhook 服务器...
    echo.
    start "Webhook 服务器" cmd /k "启动Webhook服务器.bat"
    timeout /t 3 >nul
    echo.
    echo [提示] Webhook 服务器已在新窗口中启动
    echo [提示] 请保持该窗口打开
)

echo.
echo [完成] 按任意键退出...
pause >nul
